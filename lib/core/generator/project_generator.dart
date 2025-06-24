abstract class ProjectGenerator {
  Future<void> generate() async {
    await createBaseProject();
    generateStructure();
    printSuccess();
  }

  Future<void> createBaseProject();
  void generateStructure();
  void printSuccess();
}