import 'package:r2techture/core/di/locator_initializer.dart';
import 'package:r2techture/core/environment/verifiers/brew_verifier.dart';
import 'package:r2techture/core/environment/verifiers/environment_verifier.dart';
import 'package:r2techture/core/logger/logger.dart';
import 'package:r2techture/techs/flutter/environment/flutter_verifier.dart';
import 'package:r2techture/techs/flutter/environment/fvm_verifier.dart';

class FlutterEnvironmentVerifier implements EnvironmentVerifier {
  FlutterEnvironmentVerifier({
    Logger? logger,
    FlutterVerifier? flutterVerifier,
    FvmVerifier? fvmVerifier,
    BrewVerifier? brewVerifier,
  }) : logger = logger ?? ServiceLocator.instance.resolve<Logger>(),
       flutterVerifier =
           flutterVerifier ??
           ServiceLocator.instance.resolve<FlutterVerifier>(),
       fvmVerifier = ServiceLocator.instance.resolve<FvmVerifier>(),
       brewVerifier = ServiceLocator.instance.resolve<BrewVerifier>();

  final Logger logger;
  final FlutterVerifier flutterVerifier;
  final FvmVerifier fvmVerifier;
  final BrewVerifier brewVerifier;

  @override
  Future<bool> verify() async {
    // Step 1: Check if Flutter is installed
    logger.info('Verificando el entorno de desarrollo...');
    if (await flutterVerifier.isInstalled()) return true;

    // Step 2: Check if FVM is installed
    logger.info('Flutter no está instalado. Verificando FVM...');
    if (await fvmVerifier.isInstalled()) {
      if (await fvmVerifier.isFlutterInstalledWithFVM()) return true;

      await fvmVerifier.installFlutterStableWithFVM();
      return await fvmVerifier.isFlutterInstalledWithFVM();
    }

    // Step 3: Check if FVM is installed
    logger.info('FVM no está instalado. Verificando Brew...');
    final brewIsInstalled = await brewVerifier.isInstalled();

    if (!brewIsInstalled) {
      await brewVerifier.install();
      return false;
    }

    await fvmVerifier.install();
    await fvmVerifier.installFlutterStableWithFVM();
    return await fvmVerifier.isFlutterInstalledWithFVM();
  }
}
