/// Flutter Colorable - Annotation-based colorable property extraction
///
/// This library provides annotations to mark colorable properties on widgets,
/// enabling automatic schema generation for AI-driven color theming.
///
/// ## Usage
///
/// ```dart
/// import 'package:flutter_colorable/flutter_colorable.dart';
///
/// @ColorableWidget('slider')
/// class QuanityaSlider extends StatelessWidget {
///   @Colorable(description: 'Active track color')
///   final Color activeColor;
///
///   @Colorable()
///   final Color thumbColor;
///
///   // Non-colorable properties
///   final double trackHeight;
/// }
/// ```
///
/// Then run the generator to produce colorable property metadata.
library flutter_colorable;

export 'src/annotations.dart';
export 'src/color_schema.dart';
