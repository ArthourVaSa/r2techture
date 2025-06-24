import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:r2techture/core/logger/logger.dart';
import 'package:r2techture/techs/flutter/environment/flutter_verifier.dart';
import 'package:r2techture/core/runner/process_runner.dart';
import 'package:test/test.dart';

class MockLogger extends Mock implements Logger {}

class MockProcessRunner extends Mock implements ProcessRunner {}

class MockProcess extends Mock implements Process {}

void main() {
  late MockLogger mockLogger;
  late MockProcessRunner mockProcessRunner;
  late MockProcess mockProcess;
  late FlutterVerifier flutterVerifier;

  setUp(() {
    mockLogger = MockLogger();
    mockProcessRunner = MockProcessRunner();
    mockProcess = MockProcess();
    flutterVerifier = FlutterVerifier(
      logger: mockLogger,
      runner: mockProcessRunner,
    );
  });

  group('Flutter Verifier', () {
    test('Should verified that Flutter is installed', () async {
      when(
        () => mockProcessRunner.start(
          any(),
          any(),
          runInShell: any(named: 'runInShell'),
        ),
      ).thenAnswer((_) async => mockProcess);
      when(() => mockProcess.stdout).thenAnswer(
        (_) => Stream<List<int>>.fromIterable([
          SystemEncoding().encode('Flutter 3.0.0\n'),
        ]),
      );
      when(() => mockProcess.stderr).thenAnswer((_) => Stream.empty());
      when(() => mockProcess.exitCode).thenAnswer((_) async => 0);

      final result = await flutterVerifier.isInstalled();
      expect(result, isTrue);

      verify(
        () => mockLogger.success('Flutter detectado: Flutter 3.0.0'),
      ).called(1);
    });

    test('should return false when Flutter is not installed', () async {
      when(
        () => mockProcessRunner.start(
          any(),
          any(),
          runInShell: any(named: 'runInShell'),
        ),
      ).thenAnswer((_) async => mockProcess);
      when(() => mockProcess.stdout).thenAnswer(
        (_) => Stream<List<int>>.fromIterable([SystemEncoding().encode('')]),
      );
      when(() => mockProcess.stderr).thenAnswer((_) => Stream.empty());
      when(() => mockProcess.exitCode).thenAnswer((_) async => 1);

      final result = await flutterVerifier.isInstalled();
      expect(result, isFalse);

      verify(
        () => mockLogger.warning(
          'Flutter no está instalado o no está disponible en PATH: ',
        ),
      ).called(1);
    });

    test('Should return false when an exception occurs during Flutter verification', () async {
      when(
        () => mockProcessRunner.start(
          any(),
          any(),
          runInShell: any(named: 'runInShell'),
        ),
      ).thenThrow(Exception('Error'));

      final result = await flutterVerifier.isInstalled();
      expect(result, isFalse);

      verify(
        () => mockLogger.error(
          'Flutter is not installed or not available in PATH: Exception: Error',
        ),
      ).called(1);
    });

  });
}
