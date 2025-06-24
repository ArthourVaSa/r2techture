import 'package:r2techture/core/factories/project_generator_factory.dart';
import 'package:r2techture/techs/flutter/generator/flutter_project_generator.dart';
import 'package:r2techture/core/generator/project_generator.dart';
import 'package:r2techture/models/r2_config.dart';

class ProjectGeneratorFlutterFactory implements ProjectGeneratorFactory {
  @override
  ProjectGenerator create(R2Config config) {
    return FlutterProjectGenerator(config);
  }
}
