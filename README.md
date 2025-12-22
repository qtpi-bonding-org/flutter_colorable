# Flutter Colorable

Annotation-based colorable property extraction for Flutter widgets. Enables AI-driven color theming by marking which widget properties accept colors.

## Overview

This library provides:
1. **Annotations** (`@ColorableWidget`, `@Colorable`) to mark colorable properties
2. **Code generator** that extracts colorable property metadata
3. **Schema types** for AI integration

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_colorable:
    path: ../flutter_colorable  # or git URL

dev_dependencies:
  build_runner: ^2.4.0
  flutter_colorable_generator:
    path: ../flutter_colorable/flutter_colorable_generator
```

## Usage

### 1. Annotate your widgets

```dart
import 'package:flutter/material.dart';
import 'package:flutter_colorable/flutter_colorable.dart';

part 'my_slider.g.dart';

@ColorableWidget('slider', description: 'Numeric slider input')
class MySlider extends StatelessWidget {
  @Colorable(description: 'Active track color', defaultColor: 'color1')
  final Color activeColor;

  @Colorable(description: 'Thumb color')
  final Color thumbColor;

  // Non-colorable properties
  final double value;
  final double trackHeight;

  const MySlider({
    required this.activeColor,
    required this.thumbColor,
    required this.value,
    this.trackHeight = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    // Your widget implementation
  }
}
```

### 2. Run the generator

```bash
dart run build_runner build
```

### 3. Use the generated schema

The generator creates:
- `_$MySliderColorableProperties` - List of property names
- `_$MySliderSchema` - Full schema with descriptions
- `_$MySliderFromColors()` - Factory function

```dart
// Access the schema
final schema = _$MySliderSchema;
print(schema.propertyNames); // ['activeColor', 'thumbColor']

// Generate JSON schema for AI
final jsonSchema = schema.toJsonSchema(
  availableColors: ['color1', 'color2', 'neutral1', 'neutral2'],
);
```

## Architecture

```
Your Widget Code          Generator              Output
─────────────────────────────────────────────────────────
@ColorableWidget('slider')
class MySlider {          ──────────►    _$MySliderColorableProperties
  @Colorable()                           _$MySliderSchema
  final Color activeColor;               _$MySliderFromColors()
}
```

## Why This Exists

When building AI-driven UI theming:
1. AI needs to know which properties accept colors
2. Manual maintenance of color property lists is error-prone
3. This annotation system auto-generates the metadata

## License

MIT
