import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:flutter_colorable/flutter_colorable.dart';
import 'package:source_gen/source_gen.dart';

/// Generator that processes @ColorableWidget annotations.
///
/// For each annotated class, generates:
/// 1. A const list of colorable property names
/// 2. A ColorableWidgetSchema instance
/// 3. A factory function to create the widget from AI color assignments
class ColorableGenerator extends GeneratorForAnnotation<ColorableWidget> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@ColorableWidget can only be applied to classes.',
        element: element,
      );
    }

    final classElement = element;
    final className = classElement.name;
    if (className == null) {
      throw InvalidGenerationSourceError(
        '@ColorableWidget applied to a class with no name.',
        element: element,
      );
    }
    final widgetKey = annotation.read('widgetKey').stringValue;
    final widgetDescription = annotation.peek('description')?.stringValue;

    // Find all fields with @Colorable annotation
    final colorableFields = _findColorableFields(classElement);

    if (colorableFields.isEmpty) {
      log.warning('$className has @ColorableWidget but no @Colorable fields');
    }

    return _generateCode(
      className: className,
      widgetKey: widgetKey,
      widgetDescription: widgetDescription,
      colorableFields: colorableFields,
    );
  }

  /// Finds all fields annotated with @Colorable
  List<_ColorableFieldInfo> _findColorableFields(ClassElement classElement) {
    final fields = <_ColorableFieldInfo>[];

    for (final field in classElement.fields) {
      final colorableAnnotation = _getColorableAnnotation(field);
      if (colorableAnnotation != null) {
        // Verify it's a Color type
        if (!_isColorType(field.type)) {
          log.warning(
            '${classElement.name}.${field.name} has @Colorable but is not a Color type',
          );
          continue;
        }

        final fieldName = field.name;
        if (fieldName == null) continue;

        fields.add(_ColorableFieldInfo(
          name: fieldName,
          description: colorableAnnotation.peek('description')?.stringValue,
          defaultColor: colorableAnnotation.peek('defaultColor')?.stringValue,
        ));
      }
    }

    return fields;
  }

  /// Gets the @Colorable annotation from a field, if present
  ConstantReader? _getColorableAnnotation(FieldElement field) {
    for (final annotation in field.metadata.annotations) {
      final value = annotation.computeConstantValue();
      if (value == null) continue;

      final type = value.type;
      if (type != null && type.element?.name == 'Colorable') {
        return ConstantReader(value);
      }
    }
    return null;
  }

  /// Checks if a type is dart:ui Color or flutter Color
  bool _isColorType(DartType type) {
    final element = type.element;
    if (element == null) return false;

    // Check for Color class name
    if (element.name != 'Color') return false;

    // Check it's from dart:ui or flutter
    final library = element.library;
    if (library == null) return false;

    final uri = library.identifier;
    return uri.contains('dart:ui') ||
        uri.contains('flutter') ||
        uri.contains('painting');
  }

  /// Generates the output code
  String _generateCode({
    required String className,
    required String widgetKey,
    required String? widgetDescription,
    required List<_ColorableFieldInfo> colorableFields,
  }) {
    final buffer = StringBuffer();

    // Generate property names list
    buffer.writeln('// Colorable properties for $className');
    buffer.writeln(
        'const _\$${className}ColorableProperties = <String>[');
    for (final field in colorableFields) {
      buffer.writeln("  '${field.name}',");
    }
    buffer.writeln('];');
    buffer.writeln();

    // Generate ColorableWidgetSchema
    buffer.writeln('/// Schema for $className colorable properties');
    buffer.writeln(
        'const _\$${className}Schema = ColorableWidgetSchema(');
    buffer.writeln("  widgetKey: '$widgetKey',");
    if (widgetDescription != null) {
      buffer.writeln("  description: '$widgetDescription',");
    }
    buffer.writeln('  properties: [');
    for (final field in colorableFields) {
      buffer.writeln('    ColorableProperty(');
      buffer.writeln("      name: '${field.name}',");
      if (field.description != null) {
        buffer.writeln(
            "      description: '${_escapeString(field.description!)}',");
      }
      if (field.defaultColor != null) {
        buffer.writeln("      defaultColor: '${field.defaultColor}',");
      }
      buffer.writeln('    ),');
    }
    buffer.writeln('  ],');
    buffer.writeln(');');
    buffer.writeln();

    // Generate factory function
    buffer.writeln('/// Creates $className from AI color assignments');
    buffer.writeln('$className _\$${className}FromColors({');
    buffer.writeln(
        '  required Map<String, Color> colors,');

    // Add non-colorable required parameters
    buffer.writeln('  // Add other required parameters here');
    buffer.writeln('}) {');
    buffer.writeln('  return $className(');
    for (final field in colorableFields) {
      buffer.writeln("    ${field.name}: colors['${field.name}']!,");
    }
    buffer.writeln('  );');
    buffer.writeln('}');

    return buffer.toString();
  }

  String _escapeString(String s) => s.replaceAll("'", "\\'");
}

/// Internal class to hold colorable field information
class _ColorableFieldInfo {
  final String name;
  final String? description;
  final String? defaultColor;

  _ColorableFieldInfo({
    required this.name,
    this.description,
    this.defaultColor,
  });
}
