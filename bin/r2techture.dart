import 'package:r2techture/r2techture.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Please provide a command.');
    return;
  }

  final command = arguments[0];

  print('Comando: $command');

  if (command == 'create') {
    if (arguments.length < 2) {
      print('Please provide a name for the new project.');
      return;
    }

    final yamlPath = arguments[1];

    final command = CreateProjectCommand(yamlPath: yamlPath);
    await command.execute();

    return;
  }

  print('Comando no reconocido');
}
