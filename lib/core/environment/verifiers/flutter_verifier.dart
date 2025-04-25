import 'dart:io';
import 'package:r2techture/core/environment/verifiers/verifier.dart';
import 'package:r2techture/core/logger.dart';
import 'package:r2techture/utils/process_runner.dart';

class FlutterVerifier implements Verifier {
  final Logger logger;
  final ProcessRunner runner;

  FlutterVerifier({Logger? logger, ProcessRunner? runner}) : logger = logger ?? Logger(),
        runner = runner ?? DefaultProcessRunner();

  @override
  String get name => 'Flutter';

  @override
  Future<bool> isInstalled() async {
    try {
      final result = await runner.start('fvm', ['flutter', '--version']);
      final output = await result.stdout.transform(SystemEncoding().decoder).join();
      final errorOutput = await result.stderr.transform(SystemEncoding().decoder).join();
      final exitCode = await result.exitCode;

      if (exitCode == 0) {
        logger.success('Flutter detectado: ${output.split('\n').first}');
        return true;
      } else {
        logger.warning('Flutter no está instalado o no está disponible en PATH: $errorOutput');
        return false;
      }

    } catch (e) {
      logger.error('Flutter is not installed or not available in PATH: $e');
      return false;
    }
  }

  @override
  Future<void> install() async {
    logger.warning('No se puede instalar Flutter directamente desde este verificador.');
    logger.info('Se necesita FVM para instalar Flutter.');
  }
}
