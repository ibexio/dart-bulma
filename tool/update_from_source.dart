import 'dart:async';
import 'dart:io';
import 'package:git/git.dart';
import 'package:pub_semver/pub_semver.dart';

///
/// This tool requires Docker and Git to be installed locally.
///

void main() async {
  final workingDir = await Directory.systemTemp.createTemp();
  final currentDir = Directory.current;

  print('Work $workingDir');
  print('Current $currentDir');

  final gitDir = await setupGit(workingDir);
  final tags = await getVersions(gitDir);
  await checkoutVersionTag(gitDir, tags.last);

  print('Move Bulma File');
  var bulmaFile = File('${workingDir.path}/bulma.sass');
  bulmaFile = await bulmaFile.copy('${workingDir.path}/sass/bulma.sass');
  final content = await bulmaFile.readAsString();
  await bulmaFile.writeAsString(content.replaceAll('sass/', ''));

  print('Running conversion');
  var userId = '';
  await Process.run('id', [
    '-u',
  ]).then((ProcessResult results) {
    userId = '${results.stdout}';
  });
  await Process.run('id', [
    '-g',
  ]).then((ProcessResult results) {
    userId = '$userId:${results.stdout}';
  });
  userId = userId.replaceAll('\n', '');
  await Process.run('docker', [
    'run',
    '-v',
    '${workingDir.path}/sass:/workdir',
    '-w',
    '/workdir',
    '--user',
    '$userId',
    'unibeautify/sass-convert',
    '-F',
    'sass',
    '-T',
    'scss',
    '-R',
    '/workdir'
  ]).then((ProcessResult results) {
    print(results.stdout);
  });
  print('Conversion complete');

  final workingSassDir = Directory('${workingDir.path}/sass');
  await fsCleanUpOps(workingSassDir);
  await tidyScssContents(workingSassDir);
  await copyWorkingToCurrent(workingDir, currentDir);

  print('Cleaning up');
  await workingDir.delete(recursive: true);

  print('Finished');
}

Future copyWorkingToCurrent(Directory workingDir, Directory currentDir) async {
  final oldScssDir = Directory('${workingDir.path}/sass');
  await Directory('${currentDir.path}/lib/scss').delete(recursive: true);
  await oldScssDir.rename('${currentDir.path}/lib/scss');
}

Future tidyScssContents(Directory workingSassDir) async {
  final files = workingSassDir.listSync(recursive: true);
  final fileOperations = <Future>[];
  print('Running scss file clean up operations');
  for (var f in files) {
    if (f.path.contains('.scss')) {
      final completer = Completer();
      final file = File(f.path);
      var content = await file.readAsString();
      content = content.replaceAll('.sass', '');
      await file.writeAsString(content);
      completer.complete();
      fileOperations.add(completer.future);
    }
  }
  print('Waiting on file operations');
  await Future.wait(fileOperations);
}

Future fsCleanUpOps(Directory workingSassDir) async {
  final files = workingSassDir.listSync(recursive: true);
  final fileOperations = <Future>[];
  print('Running file system clean up operations');
  for (var f in files) {
    if (f.path.contains('.scss') == false &&
        f.statSync().type == FileSystemEntityType.file) {
      fileOperations.add(f.delete());
    }
  }
  print('Waiting on file operations');
  await Future.wait(fileOperations);
}

Future<GitDir> setupGit(Directory dir,
    [String gitRemote = 'https://github.com/jgthms/bulma.git']) async {
  final gitDir = await GitDir.init(dir.uri.toFilePath());
  await gitDir.runCommand(['remote', 'add', 'origin', gitRemote]);
  await gitDir.runCommand(['fetch', '--all']);
  return gitDir;
}

Future<List<Version>> getVersions(GitDir gitDir) async {
  final tagList = await gitDir.runCommand(['tag', '--list']);
  final strings = tagList.stdout.toString().trim().split('\n');
  final versions = <Version>[];
  for (var versionString in strings) {
    versions.add(Version.parse(versionString));
  }

  // ignore: unnecessary_lambdas
  versions.sort((a, b) => Version.prioritize(a, b));

  return versions;
}

Future checkoutVersionTag(GitDir gitDir, Version tag) async {
  print('Checking out $tag');
  await gitDir.runCommand(['checkout', 'tags/$tag']);
}
