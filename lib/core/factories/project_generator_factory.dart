import 'package:r2techture/core/factories/flutter_project_generator.dart';
import 'package:r2techture/core/factories/project_generator.dart';
import 'package:r2techture/models/r2_config.dart';

class ProjectGeneratorFactory {

  static ProjectGenerator create(R2Config config) {
    return FlutterProjectGenerator(config);
  }

}