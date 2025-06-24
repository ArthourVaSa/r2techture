import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:r2techture/core/environment/verifiers/brew_verifier.dart';
import 'package:r2techture/core/logger/logger.dart';
import 'package:r2techture/core/runner/process_runner.dart';
import 'package:test/test.dart';

class MockLogger extends Mock implements Logger {}

class MockProcessRunner extends Mock implements ProcessRunner {}

class MockProcess extends Mock implements Process {}

void main() {
  late MockLogger mockLogger;
  late MockProcessRunner mockRunner;
  late MockProcess mockProcess;
  late BrewVerifier verifier;

  setUp(() {
    mockLogger = MockLogger();
    mockRunner = MockProcessRunner();
    mockProcess = MockProcess();
    verifier = BrewVerifier(logger: mockLogger, processRunner: mockRunner);
  });

  group('BrewVerifier', () {
    test('isInstalled: debe retornar true si Brew está instalado', () async {
      when(() => mockRunner.start('brew', ['--version']))
          .thenAnswer((_) async => mockProcess);
      when(() => mockProcess.stdout)
          .thenAnswer((_) => Stream.value(SystemEncoding().encode('Homebrew 4.1.0')));
      when(() => mockProcess.exitCode).thenAnswer((_) async => 0);

      final result = await verifier.isInstalled();

      expect(result, isTrue);
      verify(() => mockLogger.info('Brew detectado: Homebrew 4.1.0')).called(1);
    });

    test('isInstalled: debe retornar false si el comando retorna código diferente de 0', () async {
      when(() => mockRunner.start('brew', ['--version']))
          .thenAnswer((_) async => mockProcess);
      when(() => mockProcess.stdout)
          .thenAnswer((_) => Stream.value(SystemEncoding().encode('')));
      when(() => mockProcess.exitCode).thenAnswer((_) async => 1);

      final result = await verifier.isInstalled();

      expect(result, isFalse);
      verify(() => mockLogger.error('Brew no está instalado o no está disponible en PATH')).called(1);
    });

    test('isInstalled: debe retornar false y mostrar error si ocurre una excepción', () async {
      when(() => mockRunner.start('brew', ['--version']))
          .thenThrow(Exception('command not found'));

      final result = await verifier.isInstalled();

      expect(result, isFalse);
      verify(() => mockLogger.error(any())).called(1);
    });

    test('install: debe mostrar advertencia y comandos de instalación manual', () async {
      await verifier.install();

      verify(() => mockLogger.warning(any())).called(1);
      verify(() => mockLogger.info(any())).called(3);
    });
  });
}
