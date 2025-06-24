import 'package:r2techture/core/generator/project_generator.dart';
import 'package:r2techture/models/r2_config.dart';

abstract interface class ProjectGeneratorFactory {

  /// Creates a [ProjectGenerator] instance based on the provided [projectType].
  ///
  /// Throws an [UnsupportedError] if the project type is not supported.
  ProjectGenerator create(R2Config config);

}