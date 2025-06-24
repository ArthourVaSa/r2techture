import 'dart:io';

import 'package:r2techture/core/di/locator_initializer.dart';
import 'package:r2techture/core/generator/project_generator.dart';
import 'package:r2techture/core/logger/logger.dart';
import 'package:r2techture/models/r2_config.dart';
import 'package:r2techture/core/runner/process_runner.dart';

class FlutterProjectGenerator extends ProjectGenerator {
  final R2Config config;
  final ProcessRunner runner;
  final Logger logger;

  FlutterProjectGenerator(this.config, {ProcessRunner? runner, Logger? logger})
    : runner = runner ?? ServiceLocator.instance.resolve<ProcessRunner>(),
      logger = logger ?? ServiceLocator.instance.resolve<Logger>();

  @override
  Future<void> createBaseProject() async {
    logger.info('🚀 Generando proyecto Flutter: ${config.projectName}\n');
    final process = await runner.start('fvm', [
      'flutter',
      'create',
      config.projectName,
    ]);
    await stdout.addStream(process.stdout);
    await stderr.addStream(process.stderr);

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      logger.error(
        '❌ Error al crear el proyecto Flutter: ${config.projectName}',
      );
      return;
    }
  }

  @override
  void generateStructure() {
    // TODO: implement generateStructure
    print(
      'No se ha implementado la generación de la estructura del proyecto Flutter.',
    );
  }

  @override
  void printSuccess() {
    logger.success('Proyecto ${config.projectName} generado con éxito');
  }
}
