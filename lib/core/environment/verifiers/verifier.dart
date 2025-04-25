abstract class Verifier {
  String get name;

  Future<bool> isInstalled();
  Future<void> install();
}
