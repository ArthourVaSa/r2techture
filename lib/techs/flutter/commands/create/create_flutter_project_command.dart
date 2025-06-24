import 'package:r2techture/commands/r2_command.dart';
import 'package:r2techture/core/di/locator_initializer.dart';
import 'package:r2techture/core/environment/verifiers/environment_verifier.dart';
import 'package:r2techture/core/factories/project_generator_factory.dart';
import 'package:r2techture/core/logger/logger.dart';
import 'package:r2techture/core/yaml/yaml_loader.dart';
import 'package:r2techture/models/r2_config.dart';
import 'package:r2techture/techs/flutter/environment/flutter_environment_verifier.dart';
import 'package:r2techture/techs/flutter/factory/project_generator_flutter_factory.dart';

class CreateFlutterProjectCommand implements R2Command {
  final String yamlPath;
  final Logger logger;
  final YamlLoader yamlLoader;
  final EnvironmentVerifier environmentVerifier;
  final ProjectGeneratorFactory projectGeneratorFactory;

  CreateFlutterProjectCommand({
    required this.yamlPath,
    Logger? logger,
    YamlLoader? yamlLoader,
    EnvironmentVerifier? environmentVerifier,
    ProjectGeneratorFactory? projectGeneratorFactory,
  }) : logger = logger ?? ServiceLocator.instance.resolve<Logger>(),
       yamlLoader = yamlLoader ?? ServiceLocator.instance.resolve<YamlLoader>(),
       environmentVerifier =
           environmentVerifier ??
           ServiceLocator.instance.resolve<FlutterEnvironmentVerifier>(),
       projectGeneratorFactory =
           projectGeneratorFactory ??
           ServiceLocator.instance.resolve<ProjectGeneratorFlutterFactory>();

  @override
  Future<void> execute() async {
    final environmentOk = await environmentVerifier.verify();

    if (!environmentOk) {
      logger.error('Flutter no está instalado o no está disponible en PATH');
      return;
    }

    try {
      final yaml = yamlLoader.loadYamlFile(yamlPath);
      logger.info('Creando proyecto a partir de la configuración YAML...');
      final config = R2Config.fromYaml(yaml);

      final projectGenerator = projectGeneratorFactory.create(config);
      await projectGenerator.generate();
    } catch (e) {
      logger.error('Error al crear el proyecto: $e');
    }
  }
}
