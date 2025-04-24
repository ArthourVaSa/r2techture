import 'dart:io';

import 'package:r2techture/core/yaml/yaml_loader.dart';
import 'package:yaml/yaml.dart';

class DefaultYamlLoader implements YamlLoader{
  @override
  YamlMap loadYamlFile(String path) {
    final file = File(path);

    if (!file.existsSync()) {
      throw Exception('El archivo $path no existe.');
    }

    return loadYaml(file.readAsStringSync());

  }
}