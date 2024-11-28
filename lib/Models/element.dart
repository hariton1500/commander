import 'package:commander/globals.dart';
import 'package:commander/helpers.dart';
import 'package:flutter/material.dart';

class MapElement {
  double baseX, baseY;
  double speedX, speedY;
  int level;
  Types type;
  int radius;
  Widget? widget;
  
  MapElement({required this.baseX, required this.baseY, required this.speedX, required this.speedY, required this.level, required this.type, required this.radius, required widget});
  
  //serialize
  String toJson() {
    return '{"baseX":$baseX,"baseY":$baseY,"speedX":$speedX,"speedY":$speedY,"level":$level,"type":${type.name},"radius":$radius}';
  }
  /*deserialize
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
  }*/
}

class Base extends MapElement {
  BaseStatus baseStatus;
  bool isProducingBotsPermanently;
  /*
  @override
  final widget = Container(
            width: 20,
            height: 20,
            //color: Colors.white,
            decoration: BoxDecoration(
              color: getColor(baseStatus),
              border: Border.all(
                color: Colors.black,
                width: 2.0
              )
            ),
          );*/
  Base({required baseX, required baseY, required level, required this.baseStatus, required this.isProducingBotsPermanently}) : super(baseX: baseX, baseY: baseY, speedX: 0, speedY: 0, level: level, type: Types.base, radius: 20, widget: Container(
            width: 20,
            height: 20,
            //color: Colors.white,
            decoration: BoxDecoration(
              color: getColor(baseStatus),
              border: Border.all(
                color: Colors.black,
                width: 2.0
              )
            ),
          ));
}

class Bot extends MapElement {
  bool isAIInstalled;
  bool isWeaponInstalled;
  bool isToCaptureBases;
  bool isToDestroyEnemies;
  MapElement? target;
  static const Color botColor = Colors.grey;
  Bot({required baseX, required baseY, required speedX, required speedY, required this.isAIInstalled, required this.isWeaponInstalled, required this.isToCaptureBases, required this.isToDestroyEnemies, required level}) : super(baseX: baseX, baseY: baseY, speedX: botSpeed, speedY: botSpeed, level: 1, type: Types.mybot, radius: 10, widget: Container(
            width: 10,
            height: 10,
            color: botColor,
          ));
}

class MyBot extends Bot {
  @override
  static const Color botColor = Colors.green;
  MyBot({required baseX, required baseY, required speedX, required speedY, required level}) : super(baseX: baseX, baseY: baseY, speedX: speedX, speedY: speedY, level: level, isAIInstalled: false, isWeaponInstalled: false, isToCaptureBases: false, isToDestroyEnemies: false,);
  
}

class EnemyBot extends Bot {
  static Color botColor = Colors.red;
  EnemyBot({required baseX, required baseY, required speedX, required speedY, required level}) : super(baseX: baseX, baseY: baseY, speedX: speedX, speedY: speedY, level: level, isAIInstalled: false, isWeaponInstalled: false, isToCaptureBases: false, isToDestroyEnemies: false,);
}

class Rocket extends MapElement {
  MapElement bot;
  bool isCollided = false;
  Rocket(this.bot) : super(baseX: bot.baseX, baseY: bot.baseY, speedX: 0, speedY: 0, level: 1, type: Types.rocket, radius: 2, widget: Container(
          width: 2,
          height: 2,
          color: Colors.blue,
        ));
}


enum Types {wall, base, mybot, enemybot, rocket}
enum BaseStatus {neutral, mine, enemies}