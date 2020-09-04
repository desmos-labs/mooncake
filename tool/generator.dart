import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';

part 'generator.g.dart';

@JsonSerializable(createToJson: false)
class Selection {
  @JsonKey(name: 'icons')
  final List<Icon> icons;

  Selection(this.icons);

  factory Selection.fromJson(Map<String, dynamic> json) =>
      _$SelectionFromJson(json);
}

@JsonSerializable(createToJson: false)
class Icon {
  @JsonKey(name: 'properties')
  final Properties properties;

  Icon(this.properties);

  factory Icon.fromJson(Map<String, dynamic> json) => _$IconFromJson(json);
}

@JsonSerializable(createToJson: false)
class Properties {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'code')
  final int code;

  Properties(this.name, this.code);

  factory Properties.fromJson(Map<String, dynamic> json) =>
      _$PropertiesFromJson(json);
}

void main() async {
  final path = dirname(Platform.script.toFilePath());
  final contents = File(join(path, 'selection.json')).readAsStringSync();
  final selection = Selection.fromJson(
    jsonDecode(contents) as Map<String, dynamic>,
  );

  final output = File(join(path, 'icons.dart'));
  output.writeAsStringSync(
    "import 'package:flutter/widgets.dart';\n\n",
  );
  output.writeAsStringSync(
    "import 'icon_data.dart';\n\n",
    mode: FileMode.append,
  );

  output.writeAsStringSync(
    '/// This class has been auto generated. Do not edit or change manually.\n',
    mode: FileMode.append,
  );
  output.writeAsStringSync('class MooncakeIcons { \n', mode: FileMode.append);
  selection.icons.forEach((icon) {
    output.writeAsStringSync(_getIconLine(icon), mode: FileMode.append);
  });
  output.writeAsStringSync('}\n', mode: FileMode.append);
}

String _getIconLine(Icon icon) {
  final name = icon.properties.name.camelCase;
  final code = icon.properties.code.toRadixString(16);
  return '\tstatic const IconData $name = IconDataMooncake(0x$code);\n';
}
