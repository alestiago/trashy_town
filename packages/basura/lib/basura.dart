/// Flutter widgets and themes implementing the Trashy Road design language,
/// named "Basura".
library basura;

import 'package:meta/meta.dart';

export 'src/basura.dart';

/// Metadata for the Basura package.
abstract class Basura {
  /// The name of the Basura package.
  ///
  /// This is defined in the `pubspec.yaml` file.
  ///
  /// It is used to define the `package` property of a `TextStyle` to use fonts
  /// defined in other packages.
  @internal
  static const packageName = 'basura';
}
