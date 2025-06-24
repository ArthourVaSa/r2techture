abstract interface class DependencyLocator {
  /// Registers a dependency of type [T] with an instance of [instance].
  T resolve<T extends Object>();
}
