import 'dart:io';

Future<bool> checkFlutterInstalled() async {
  try {
    final result = await Process.run('fvm', [
      'flutter',
      '--version',
    ], runInShell: true);

    if (result.exitCode != 0) {
      print('❌ Error al ejecutar Flutter: ${result.stderr}');
      return false;
    }

    print('✅ Flutter detectado: ${result.stdout.split('\n').first}');
    return result.exitCode == 0;
  } catch (e) {
    print('❌ Flutter no está instalado o no está disponible en PATH');
    return false;
  }
}
