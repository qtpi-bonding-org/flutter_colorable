import 'package:flutter/material.dart';
import 'package:flutter_colorable/flutter_colorable.dart';

part 'example_widget.g.dart';

/// Minimal example widget to test the generator
@ColorableWidget('example')
class ExampleWidget extends StatelessWidget {
  @Colorable() final Color primaryColor;
  @Colorable() final Color secondaryColor;

  final String text;

  const ExampleWidget({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Text(text, style: TextStyle(color: secondaryColor)),
    );
  }
}
