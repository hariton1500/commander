import 'dart:convert';
import 'dart:io';

class MapElement {
  late double baseX, baseY, speedX, speedY;
  late int level;
  late Types type;
  late int radius = 10 ;
  
  MapElement(this.baseX, this.baseY, this.speedX, this.speedY, this.level, this.type, this.radius);
  
  //serialize
  String toJson() {
    return '{"baseX":$baseX,"baseY":$baseY,"speedX":$speedX,"speedY":$speedY,"level":$level,"type":${type.name},"radius":$radius}';
  }
  //deserialize
  MapElement.fromJson(String json) {
    var jsonMap = jsonDecode(json);
    baseX = jsonMap['baseX'];
    baseY = jsonMap['baseY'];
    speedX = jsonMap['speedX'];
    speedY = jsonMap['speedY'];
    level = jsonMap['level'];
    type = Types.values.firstWhere((e) => e.name == jsonMap['type']);
    radius = jsonMap['radius'];
  }

  loadFromFile(String path) {
    var file = File(path);
    var json = file.readAsStringSync();
    MapElement.fromJson(json);
  }

  saveToFile(String path) {
    var file = File(path);
    file.writeAsStringSync(toJson());
  }
}

enum Types {wall, base, mybot, enemybot}