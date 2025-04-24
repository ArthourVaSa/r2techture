import 'package:mocktail/mocktail.dart';
import 'package:r2techture/commands/create/create_project_command.dart';
import 'package:r2techture/core/factories/project_generator.dart';
import 'package:r2techture/core/logger.dart';
import 'package:r2techture/core/yaml/yaml_loader.dart';
import 'package:r2techture/models/r2_config.dart';
import 'package:r2techture/utils/process_runner.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

class MockLogger extends Mock implements Logger {}

class MockProjectGenerator extends Mock implements ProjectGenerator {}

class MockYamlLoader extends Mock implements YamlLoader {}

class FakeProjectGeneratorFactory {
  static ProjectGenerator create(R2Config config) {
    return MockProjectGenerator();
  }
}

void main() {
  late MockLogger mockLogger;
  late MockProjectGenerator mockProjectGenerator;
  late MockYamlLoader mockYamlLoader;

  setUp(() {
    mockLogger = MockLogger();
    mockProjectGenerator = MockProjectGenerator();
    mockYamlLoader = MockYamlLoader();
  });

  setUpAll(() {
    registerFallbackValue(R2Config(projectName: 'test'));
  });

  group('CreateProjectCommand', () {
    test('should execute generate() and logging successfully', () async {
      final yamlpath = 'test/fixtures/test.yaml';

      final command = CreateProjectCommand(
        yamlPath: yamlpath,
        logger: mockLogger,
        runner: DefaultProcessRunner(),
        yamlLoader: mockYamlLoader,
      );

      when(
        () => mockYamlLoader.loadYamlFile(any()),
      ).thenReturn(YamlMap.wrap({'project_name': 'test'}));
      when(() => mockProjectGenerator.generate()).thenAnswer((_) async {});
      when(() => mockLogger.info(any())).thenReturn(null);
      when(() => mockLogger.success(any())).thenReturn(null);
      when(() => mockProjectGenerator.generate()).thenAnswer((_) async {});
      when(() => mockLogger.info(any())).thenReturn(null);
      when(() => mockLogger.success(any())).thenReturn(null);

      await command.execute();

      verify(() => mockLogger.info(any())).called(greaterThanOrEqualTo(1));
      verify(() => mockLogger.success(any())).called(greaterThanOrEqualTo(1));
    });
  });
}
