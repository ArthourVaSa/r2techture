import 'dart:io';

import 'package:r2techture/core/di/locator_initializer.dart';
import 'package:r2techture/core/environment/verifiers/verifier.dart';
import 'package:r2techture/core/logger/logger.dart';
import 'package:r2techture/core/runner/process_runner.dart';

class FvmVerifier implements Verifier {
  final Logger logger;
  final ProcessRunner processRunner;

  FvmVerifier({Logger? logger, ProcessRunner? processRunner})
    : logger = logger ?? ServiceLocator.instance.resolve<Logger>(),
      processRunner = processRunner ?? ServiceLocator.instance.resolve<ProcessRunner>();

  @override
  String get name => 'FVM';

  @override
  Future<bool> isInstalled() async {
    try {
      logger.info('Verificando si FVM está instalado...');
      final process = await processRunner.start('fvm', ['--version']);
      final output =
          await process.stdout.transform(SystemEncoding().decoder).join();
      final exitCode = await process.exitCode;

      if (exitCode == 0) {
        logger.info('FVM detectado: ${output.split('\n').first}');
        return true;
      }

      logger.error('FVM respondió con error: $output');
      return false;
    } catch (e) {
      logger.error('Error al verificar FVM: $e');
      return false;
    }
  }

  @override
  Future<void> install() async {
    try {
      logger.info('Instalando FVM usando Brew...');

      final process = await processRunner.start('brew', [
        'install',
        'fvm',
      ]);
      final output =
          await process.stdout.transform(SystemEncoding().decoder).join();
      final exitCode = await process.exitCode;

      if (exitCode == 0) {
        logger.success('FVM instalado correctamente.');
      } else {
        logger.error('Falló la instalación de FVM:\n$output');
      }

    } catch (e) {
      logger.error('No se pudo instalar FVM:\n$e'); 
    }
  }

  Future<bool> isFlutterInstalledWithFVM() async {
    try {
      final process = await processRunner.start('fvm', [
        'flutter',
        '--version',
      ]);
      final output =
          await process.stdout.transform(SystemEncoding().decoder).join();
      final exitCode = await process.exitCode;

      if (exitCode == 0) {
        logger.info('Flutter detectado con FVM: ${output.split('\n').first}');
        return true;
      }

      logger.error('FVM no tiene Flutter configurado:\n$output');
      return false;
    } catch (e) {
      logger.error('No se pudo verificar Flutter a través de FVM:\n$e');
      return false;
    }
  }

  Future<void> installFlutterStableWithFVM() async {
    try {
      final process = await processRunner.start('fvm', [
        'install',
        'stable',
      ]);
      final output =
          await process.stdout.transform(SystemEncoding().decoder).join();
      final exitCode = await process.exitCode;

      if (exitCode == 0) {
        logger.success('Flutter estable instalado con FVM.');
      } else {
        logger.error('Error al instalar Flutter estable con FVM:\n$output');
      }
    } catch (e) {
      logger.error('No se pudo instalar Flutter Stable usando FVM:\n$e');
    }
  }

}
