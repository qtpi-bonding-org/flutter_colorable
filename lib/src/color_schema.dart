/// Color schema types for AI theming integration.
library;

/// Represents a colorable property extracted from a widget.
class ColorableProperty {
  /// Property name (e.g., 'activeColor', 'thumbColor')
  final String name;

  /// Human-readable description
  final String? description;

  /// Default palette color key
  final String? defaultColor;

  const ColorableProperty({
    required this.name,
    this.description,
    this.defaultColor,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        if (defaultColor != null) 'default': defaultColor,
      };

  @override
  String toString() => 'ColorableProperty($name)';
}

/// Metadata for a colorable widget, containing all its colorable properties.
class ColorableWidgetSchema {
  /// Widget identifier key
  final String widgetKey;

  /// Widget description
  final String? description;

  /// List of colorable properties
  final List<ColorableProperty> properties;

  const ColorableWidgetSchema({
    required this.widgetKey,
    this.description,
    required this.properties,
  });

  /// Property names as a simple list
  List<String> get propertyNames => properties.map((p) => p.name).toList();

  /// Generate JSON schema for AI consumption
  Map<String, dynamic> toJsonSchema({
    List<String> availableColors = const [
      'color1',
      'color2',
      'color3',
      'neutral1',
      'neutral2',
    ],
  }) {
    return {
      'type': 'object',
      'properties': {
        for (final prop in properties)
          prop.name: {
            'type': 'string',
            'enum': availableColors,
            if (prop.description != null) 'description': prop.description,
          },
      },
      'required': propertyNames,
    };
  }

  Map<String, dynamic> toJson() => {
        'widgetKey': widgetKey,
        if (description != null) 'description': description,
        'properties': properties.map((p) => p.toJson()).toList(),
      };

  @override
  String toString() =>
      'ColorableWidgetSchema($widgetKey, ${properties.length} properties)';
}

/// Registry of all colorable widgets in the application.
///
/// This is typically populated by the code generator.
class ColorableRegistry {
  final Map<String, ColorableWidgetSchema> _schemas = {};

  /// Register a widget schema
  void register(ColorableWidgetSchema schema) {
    _schemas[schema.widgetKey] = schema;
  }

  /// Get schema for a widget key
  ColorableWidgetSchema? getSchema(String widgetKey) => _schemas[widgetKey];

  /// Get all registered widget keys
  List<String> get widgetKeys => _schemas.keys.toList();

  /// Get all registered schemas
  List<ColorableWidgetSchema> get schemas => _schemas.values.toList();

  /// Generate combined JSON schema for all widgets
  Map<String, dynamic> toJsonSchema({
    List<String> availableColors = const [
      'color1',
      'color2',
      'color3',
      'neutral1',
      'neutral2',
    ],
  }) {
    return {
      for (final schema in _schemas.values)
        schema.widgetKey: schema.toJsonSchema(availableColors: availableColors),
    };
  }
}
