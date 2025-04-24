import 'dart:io';

Future<bool> generateFlutterProject(String name) async {
  print('🚀 Ejecutando: flutter create $name');
  
  final process = await Process.start('fvm', ['flutter', 'create', name], runInShell: true);

  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);

  final exitCode = await process.exitCode;
  return exitCode == 0;
}