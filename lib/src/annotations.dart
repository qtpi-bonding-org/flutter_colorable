/// Annotations for marking colorable properties on Flutter widgets.
library;

/// Marks a widget class as having colorable properties for AI theming.
///
/// The [widgetKey] is used to identify this widget type in the generated
/// schema and factory mappings.
///
/// Example:
/// ```dart
/// @ColorableWidget('slider')
/// class QuanityaSlider extends StatelessWidget {
///   // ...
/// }
/// ```
class ColorableWidget {
  /// Unique identifier for this widget type.
  /// Used in schema generation and factory mapping.
  final String widgetKey;

  /// Optional description of the widget's purpose.
  final String? description;

  const ColorableWidget(this.widgetKey, {this.description});
}

/// Marks a Color property as colorable by AI theming system.
///
/// Properties marked with this annotation will be included in the
/// generated color schema, allowing AI to assign palette colors.
///
/// Example:
/// ```dart
/// @Colorable(description: 'Color of the active track portion')
/// final Color activeColor;
/// ```
class Colorable {
  /// Human-readable description of what this color controls.
  /// Used in schema generation to help AI understand the property.
  final String? description;

  /// Default palette color key (e.g., 'color1', 'neutral2').
  /// If not specified, AI will choose from available palette colors.
  final String? defaultColor;

  const Colorable({this.description, this.defaultColor});
}
