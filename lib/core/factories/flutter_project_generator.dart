import 'dart:io';

import 'package:r2techture/core/factories/project_generator.dart';
import 'package:r2techture/core/logger.dart';
import 'package:r2techture/models/r2_config.dart';
import 'package:r2techture/utils/process_runner.dart';

class FlutterProjectGenerator extends ProjectGenerator {
  final R2Config config;
  final ProcessRunner runner;
  final Logger logger = Logger();

  FlutterProjectGenerator(this.config, {
    ProcessRunner? runner,
  }) : runner = runner ?? DefaultProcessRunner();
  
  @override
  Future<void> createBaseProject() async {
    logger.info('🚀 Generando proyecto Flutter: ${config.projectName}\n');
    final process = await runner.start('fvm', ['flutter', 'create', config.projectName]);
    await stdout.addStream(process.stdout);
    await stderr.addStream(process.stderr);

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      logger.error('❌ Error al crear el proyecto Flutter: ${config.projectName}');
      return;
    }
  }
  
  @override
  void generateStructure() {
    // TODO: implement generateStructure
    print('No se ha implementado la generación de la estructura del proyecto Flutter.');
  }
  
  @override
  void printSuccess() {
    logger.success('Proyecto ${config.projectName} generado con éxito');
  }

  
}
