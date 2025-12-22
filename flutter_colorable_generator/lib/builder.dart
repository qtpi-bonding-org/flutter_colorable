import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/colorable_generator.dart';

/// Builder factory for flutter_colorable_generator.
///
/// This is the entry point for build_runner to create the generator.
Builder colorableBuilder(BuilderOptions options) => SharedPartBuilder(
      [ColorableGenerator()],
      'colorable',
    );
