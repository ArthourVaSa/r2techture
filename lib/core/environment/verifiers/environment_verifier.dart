abstract interface class EnvironmentVerifier {
  /// Verifies the current environment.
  ///
  /// Returns `true` if the environment is valid, otherwise `false`.
  Future<bool> verify();
}