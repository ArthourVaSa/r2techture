import 'package:yaml/yaml.dart';

abstract class YamlLoader {
  YamlMap loadYamlFile(String path);
}
