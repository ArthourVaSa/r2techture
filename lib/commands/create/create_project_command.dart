import 'package:r2techture/commands/r2_command.dart';
import 'package:r2techture/core/factories/project_generator_factory.dart';
import 'package:r2techture/core/flutter_checker.dart';
import 'package:r2techture/core/logger.dart';
import 'package:r2techture/core/yaml/default_yaml_loader.dart';
import 'package:r2techture/core/yaml/yaml_loader.dart';
import 'package:r2techture/core/yaml_loader.dart';
import 'package:r2techture/models/r2_config.dart';
import 'package:r2techture/utils/process_runner.dart';

class CreateProjectCommand implements R2Command {

  final String yamlPath;
  final Logger logger;
  final ProcessRunner runner;
  final YamlLoader yamlLoader;

  CreateProjectCommand({
    required this.yamlPath,
    Logger? logger,
    ProcessRunner? runner,
    YamlLoader? yamlLoader,
  }) : 
      logger = logger ?? Logger(),
      runner = runner ?? DefaultProcessRunner(),
      yamlLoader = yamlLoader ?? DefaultYamlLoader();

  @override
  Future<void> execute() async {
    final flutterInstalled = await checkFlutterInstalled();
    if (!flutterInstalled) {
      logger.error('Flutter no está instalado o no está disponible en PATH');
      return;
    }

    try {
      final yaml = yamlLoader.loadYamlFile(yamlPath);
      logger.info('Creando proyecto a partir de la configuración YAML...');
      final config = R2Config.fromYaml(yaml);

      final projectGenerator = ProjectGeneratorFactory.create(config);
      await projectGenerator.generate();
    } catch (e) {
      logger.error('Error al crear el proyecto: $e');
    }
  }
}
