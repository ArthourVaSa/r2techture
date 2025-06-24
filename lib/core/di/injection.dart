import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:r2techture/core/di/injection.config.dart';

@InjectableInit()
Future<void> configureDependencies(GetIt getIt) async => getIt.init();
