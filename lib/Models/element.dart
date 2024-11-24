import 'dart:convert';
import 'dart:io';

class MapElement {
  late double baseX, baseY, speedX, speedY;
  late int level;
  late Types type;
  late int radius = 10;
  late BaseStatus baseStatus = BaseStatus.neutral;
  late bool isProducingBotsPermanently;
  late bool isToCaptureBases;
  late bool isToDestroyEnemies;
  late bool isAIInstalled;
  late bool isWeaponInstalled;

  late num targetX, targetY;
  
  MapElement(this.baseX, this.baseY, this.speedX, this.speedY, this.level, this.type, this.radius, this.baseStatus, this.isProducingBotsPermanently, this.isToCaptureBases, this.isToDestroyEnemies, this.isAIInstalled, this.isWeaponInstalled, this.targetX, this.targetY);
  
  //serialize
  String toJson() {
    return '{"baseX":$baseX,"baseY":$baseY,"speedX":$speedX,"speedY":$speedY,"level":$level,"type":${type.name},"radius":$radius, "baseStatus": ${baseStatus.name}, "isProducingBotsPermanently": $isProducingBotsPermanently, "isToCaptureBases": $isToCaptureBases, "isToDestroyEnemies": $isToDestroyEnemies, "isAIInstalled": $isAIInstalled, "isWeaponInstalled": $isWeaponInstalled, "targetX": $targetX, "targetY": $targetY}';
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
    baseStatus = jsonMap['baseStatus'];
    isProducingBotsPermanently = jsonMap['isProducingBotsPermanently'];
    isToCaptureBases = jsonMap['isToCaptureBases'];
    isToDestroyEnemies = jsonMap['isToDestroyEnemies'];
    isAIInstalled = jsonMap['isAIInstalled'];
    isWeaponInstalled = jsonMap['isWeaponInstalled'];
    targetX = jsonMap['targetX'];
    targetY = jsonMap['targetY'];
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
enum BaseStatus {neutral, mine, enemies}