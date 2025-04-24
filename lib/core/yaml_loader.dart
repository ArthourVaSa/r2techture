import 'dart:io';

import 'package:yaml/yaml.dart';

YamlMap loadYamlFile(String path) {

  final file = File(path);

  if (!file.existsSync()) {
    throw Exception('El archivo $path no existe.');
  }

  return loadYaml(file.readAsStringSync());

}