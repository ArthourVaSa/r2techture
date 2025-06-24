import 'package:r2techture/core/di/locator_initializer.dart';
import 'package:r2techture/core/logger/logger.dart';
import 'package:r2techture/r2techture.dart';

Future<void> main(List<String> arguments) async {
  await ServiceLocator.initialize();

  final logger = ServiceLocator.instance.resolve<Logger>();

  if (arguments.isEmpty) {
    logger.warning('No command provided. Use "create" to create a new project.');
    return;
  }

  final command = arguments[0];

  if (command == 'create') {
    if (arguments.length < 2) {
      logger.error('No se ha proporcionado la ruta del archivo YAML.');
      return;
    }

    final yamlPath = arguments[1];

    final command = CreateFlutterProjectCommand(yamlPath: yamlPath);
    await command.execute();

    return;
  }

  logger.error('Comando desconocido: $command');
}
