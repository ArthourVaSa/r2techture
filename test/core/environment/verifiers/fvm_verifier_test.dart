import 'dart:io';
import 'package:mocktail/mocktail.dart';
import 'package:r2techture/core/logger/logger.dart';
import 'package:r2techture/core/runner/process_runner.dart';
import 'package:r2techture/techs/flutter/environment/fvm_verifier.dart';
import 'package:test/test.dart';

class MockLogger extends Mock implements Logger {}

class MockProcessRunner extends Mock implements ProcessRunner {}

class MockProcess extends Mock implements Process {}

void main() {
  late MockLogger mockLogger;
  late MockProcessRunner mockRunner;
  late MockProcess mockProcess;
  late FvmVerifier verifier;

  setUp(() {
    mockLogger = MockLogger();
    mockRunner = MockProcessRunner();
    mockProcess = MockProcess();
    verifier = FvmVerifier(logger: mockLogger, processRunner: mockRunner);
  });

  group('FvmVerifier', () {
    test('isInstalled: debe retornar true si FVM está instalado', () async {
      when(() => mockRunner.start('fvm', ['--version']))
          .thenAnswer((_) async => mockProcess);
      when(() => mockProcess.stdout)
          .thenAnswer((_) => Stream.value(SystemEncoding().encode('FVM 2.4.0')));
      when(() => mockProcess.exitCode).thenAnswer((_) async => 0);

      final result = await verifier.isInstalled();

      expect(result, isTrue);
      verify(() => mockLogger.info('FVM detectado: FVM 2.4.0')).called(1);
    });

    test('isInstalled: debe retornar false si FVM no está instalado', () async {
      when(() => mockRunner.start('fvm', ['--version']))
          .thenThrow(const ProcessException('fvm', ['--version'], 'not found', 1));
      when(() => mockLogger.error(any())).thenReturn(null);

      final result = await verifier.isInstalled();

      expect(result, isFalse);
      verify(() => mockLogger.error(any())).called(1);
    });

    test('isFlutterInstalledWithFVM: true si flutter está con FVM', () async {
      when(() => mockRunner.start('fvm', ['flutter', '--version']))
          .thenAnswer((_) async => mockProcess);
      when(() => mockProcess.stdout)
          .thenAnswer((_) => Stream.value(SystemEncoding().encode('Flutter 3.0.0')));
      when(() => mockProcess.exitCode).thenAnswer((_) async => 0);

      final result = await verifier.isFlutterInstalledWithFVM();

      expect(result, isTrue);
      verify(() => mockLogger.info('Flutter detectado con FVM: Flutter 3.0.0')).called(1);
    });

    test('isFlutterInstalledWithFVM: false si falla el comando', () async {
      when(() => mockRunner.start('fvm', ['flutter', '--version']))
          .thenThrow(const ProcessException('fvm', ['flutter', '--version'], 'not found', 1));

      final result = await verifier.isFlutterInstalledWithFVM();

      expect(result, isFalse);
      verify(() => mockLogger.error(any())).called(1);
    });

    test('installFlutterStableWithFVM: éxito', () async {
      when(() => mockRunner.start('fvm', ['install', 'stable']))
          .thenAnswer((_) async => mockProcess);
      when(() => mockProcess.stdout)
          .thenAnswer((_) => Stream.value(SystemEncoding().encode('Instalando Flutter...')));
      when(() => mockProcess.exitCode).thenAnswer((_) async => 0);

      await verifier.installFlutterStableWithFVM();

      verify(() => mockLogger.success('Flutter estable instalado con FVM.')).called(1);
    });

    test('installFlutterStableWithFVM: falla', () async {
      when(() => mockRunner.start('fvm', ['install', 'stable']))
          .thenAnswer((_) async => mockProcess);
      when(() => mockProcess.stdout)
          .thenAnswer((_) => Stream.value(SystemEncoding().encode('Error de instalación')));
      when(() => mockProcess.exitCode).thenAnswer((_) async => 1);

      await verifier.installFlutterStableWithFVM();

      verify(() => mockLogger.error(any())).called(1);
    });

    test('install: éxito al instalar FVM con brew', () async {
      when(() => mockRunner.start('brew', ['install', 'fvm']))
          .thenAnswer((_) async => mockProcess);
      when(() => mockProcess.stdout)
          .thenAnswer((_) => Stream.value(SystemEncoding().encode('Instalación exitosa')));
      when(() => mockProcess.exitCode).thenAnswer((_) async => 0);

      await verifier.install();

      verify(() => mockLogger.success('FVM instalado correctamente.')).called(1);
    });

    test('install: error al instalar con brew', () async {
      when(() => mockRunner.start('brew', ['install', 'fvm']))
          .thenAnswer((_) async => mockProcess);
      when(() => mockProcess.stdout)
          .thenAnswer((_) => Stream.value(SystemEncoding().encode('Error')));
      when(() => mockProcess.exitCode).thenAnswer((_) async => 1);

      await verifier.install();

      verify(() => mockLogger.error(any())).called(1);
    });
  });
}
