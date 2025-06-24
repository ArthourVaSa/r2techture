import 'package:get_it/get_it.dart';
import 'package:r2techture/core/di/dependency_locator.dart';

class GetItDependencyLocator implements DependencyLocator {

  final GetIt _getIt;

  GetItDependencyLocator(this._getIt);

  @override
  T resolve<T extends Object>() => _getIt<T>();
}