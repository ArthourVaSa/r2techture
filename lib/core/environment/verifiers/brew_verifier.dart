import 'dart:io';

import 'package:r2techture/core/di/locator_initializer.dart';
import 'package:r2techture/core/environment/verifiers/verifier.dart';
import 'package:r2techture/core/logger/logger.dart';
import 'package:r2techture/core/runner/process_runner.dart';

class BrewVerifier implements Verifier {
  final Logger logger;
  final ProcessRunner processRunner;

  BrewVerifier({Logger? logger, ProcessRunner? processRunner})
    : logger = logger ?? ServiceLocator.instance.resolve<Logger>(),
      processRunner =
          processRunner ?? ServiceLocator.instance.resolve<ProcessRunner>();

  @override
  String get name => 'Brew';

  @override
  Future<void> install() async {
    logger.warning(
      'Brew no está instalado y no puede instalarse automáticamente.',
    );
    logger.info(
      '👉 Puedes instalarlo ejecutando este comando en tu terminal:\n',
    );
    logger.info(
      '/bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\n',
    );
    logger.info('🔁 Luego vuelve a ejecutar: r2 create <archivo.yaml>');
  }

  @override
  Future<bool> isInstalled() async {
    try {
      final process = await processRunner.start('brew', ['--version']);
      final output =
          await process.stdout.transform(SystemEncoding().decoder).join();
      final exitCode = await process.exitCode;

      if (exitCode == 0) {
        logger.info('Brew detectado: ${output.split('\n').first}');
        return true;
      } else {
        logger.error('Brew no está instalado o no está disponible en PATH');
        return false;
      }
    } catch (e) {
      logger.error('Error al verificar Brew:\n$e');
      return false;
    }
  }
}
