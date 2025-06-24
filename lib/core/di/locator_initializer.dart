import 'package:get_it/get_it.dart';
import 'package:r2techture/core/di/dependency_locator.dart';
import 'package:r2techture/core/di/get_it_dependency_locator.dart';
import 'package:r2techture/core/di/injection.dart';
import 'package:r2techture/core/environment/verifiers/brew_verifier.dart';
import 'package:r2techture/core/logger/logger.dart';
import 'package:r2techture/core/runner/default_process_runner.dart';
import 'package:r2techture/core/runner/process_runner.dart';
import 'package:r2techture/core/yaml/default_yaml_loader.dart';
import 'package:r2techture/core/yaml/yaml_loader.dart';
import 'package:r2techture/techs/flutter/environment/flutter_environment_verifier.dart';
import 'package:r2techture/techs/flutter/environment/flutter_verifier.dart';
import 'package:r2techture/techs/flutter/environment/fvm_verifier.dart';
import 'package:r2techture/techs/flutter/factory/project_generator_flutter_factory.dart';

class ServiceLocator {
  static final GetIt _getIt = GetIt.instance;

  static late final DependencyLocator instance;

  static Future<void> initialize() async {
    await configureDependencies(_getIt);
    instance = GetItDependencyLocator(_getIt);

    // Register Core Dependencies
    _getIt.registerLazySingleton<Logger>(() => Logger());
    _getIt.registerLazySingleton<ProcessRunner>(() => DefaultProcessRunner());
    _getIt.registerLazySingleton<YamlLoader>(() => DefaultYamlLoader());
    _getIt.registerSingleton<BrewVerifier>(BrewVerifier());
    _getIt.registerSingleton<FvmVerifier>(FvmVerifier());

    // Register Flutter Feature
    _getIt.registerSingleton<FlutterVerifier>(FlutterVerifier());
    _getIt.registerSingleton<FlutterEnvironmentVerifier>(FlutterEnvironmentVerifier());
    _getIt.registerFactory<ProjectGeneratorFlutterFactory>(() => ProjectGeneratorFlutterFactory());

  }
}
