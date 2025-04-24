import 'package:yaml/yaml.dart';

class R2Config {

  final String projectName;

  R2Config({
    required this.projectName,
  });

  factory R2Config.fromYaml(YamlMap yaml) {
    return R2Config(
      projectName: yaml['project_name'] ?? 'r2_project',
    );
  }

}