# [bulma](https://bulma.io)

[Bulma](https://bulma.io/) is a **modern SCSS framework** based on [Flexbox](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Using_CSS_flexible_boxes).

## Example

You can find basic example usage in the [github repo's](https://github.com/ibexio/dart-bulma) example folder.

## Usage

Add Sass and Builder runner to the project pubspec.yaml:

```yaml
dev_dependencies:
  sass_builder: ^2.1.3
  build_runner: ^1.0.1
```

Create a SCSS file and import bulma and edit any variable you need:

```scss
// 1. Import the initial variables
@import "package:bulma/scss/utilities/initial-variables";
@import "package:bulma/scss/utilities/functions";

// 2. Set your own initial variables
// Update blue
$blue: #72d0eb;
// Add pink and its invert
$pink: #ffb3b3;
$pink-invert: #fff;
// Add a serif family
$family-serif: "Merriweather", "Georgia", serif;

// 3. Set the derived variables
// Use the new pink as the primary color
$primary: $pink;
$primary-invert: $pink-invert;
// Use the existing orange as the danger color
$danger: $orange;
// Use the new serif family
$family-primary: $family-serif;

// 4. Setup your Custom Colors
$linkedin: #0077b5;
$linkedin-invert: findColorInvert($linkedin);
$twitter: #55acee;
$twitter-invert: findColorInvert($twitter);
$github: #333;
$github-invert: findColorInvert($github);

// 5. Add new color variables to the color map.
@import "package:bulma/scss/utilities/derived-variables";
$addColors: (
  "twitter":($twitter, $twitter-invert),
  "linkedin": ($linkedin, $linkedin-invert),
  "github": ($github, $github-invert)
);
$colors: map-merge($colors, $addColors);

// 6. Import the rest of Bulma
@import "package:bulma/scss/bulma";
```

Alternatively If you want to customize which bulma parts are included to minimize the end size of your css, you can use the below and simply uncomment the parts you want to include.

```scss
// Utilities
@import "package:bulma/scss/utilities/initial-variables";
@import "package:bulma/scss/utilities/functions";
@import "package:bulma/scss/utilities/derived-variables";
@import "package:bulma/scss/utilities/animations";
@import "package:bulma/scss/utilities/mixins";
@import "package:bulma/scss/utilities/controls";
// Custom Variables

// Base
@import "package:bulma/scss/base/minireset";
@import "package:bulma/scss/base/generic";
@import "package:bulma/scss/base/helpers";
// Elements
// @import "package:bulma/scss/elements/box";
// @import "package:bulma/scss/elements/button";
// @import "package:bulma/scss/elements/container";
// @import "package:bulma/scss/elements/content";
// @import "package:bulma/scss/elements/form";
// @import "package:bulma/scss/elements/icon";
// @import "package:bulma/scss/elements/image";
// @import "package:bulma/scss/elements/notification";
// @import "package:bulma/scss/elements/progress";
// @import "package:bulma/scss/elements/table";
// @import "package:bulma/scss/elements/tag";
// @import "package:bulma/scss/elements/title";
// @import "package:bulma/scss/elements/other";
// Components
// @import "package:bulma/scss/components/breadcrumb";
// @import "package:bulma/scss/components/card";
// @import "package:bulma/scss/components/dropdown";
// @import "package:bulma/scss/components/level";
// @import "package:bulma/scss/components/media";
// @import "package:bulma/scss/components/menu";
// @import "package:bulma/scss/components/message";
// @import "package:bulma/scss/components/modal";
// @import "package:bulma/scss/components/navbar";
// @import "package:bulma/scss/components/pagination";
// @import "package:bulma/scss/components/panel";
// @import "package:bulma/scss/components/tabs";
// Grid
@import "package:bulma/scss/grid/columns";
// @import "package:bulma/scss/grid/tiles";
// Layout
// @import "package:bulma/scss/layout/hero";
// @import "package:bulma/scss/layout/section";
// @import "package:bulma/scss/layout/footer";

// Custom SCSS

```

## Documentation

Documentation for the Bulma framework can be found here [Bulma Documentation](https://bulma.io/documentation)

## Bugs and Features

Report problems with this package to [https://github.com/ibexio/dart-bulma](https://github.com/ibexio/dart-bulma)

Report problems with the core framework to [https://github.com/jgthms/bulma](https://github.com/jgthms/bulma)

## Copyright and license

Dart package is released under the [MIT license](https://github.com/jgthms/bulma/blob/master/LICENSE).
