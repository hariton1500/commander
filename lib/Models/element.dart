import 'package:commander/globals.dart';
import 'package:commander/helpers.dart';
import 'package:flutter/material.dart';

class MapElement {
  double baseX, baseY;
  double speedX, speedY;
  int level;
  Types type;
  int radius;
  //Widget? widget;
  
  MapElement({required this.baseX, required this.baseY, required this.speedX, required this.speedY, required this.level, required this.type, required this.radius});
  
  //serialize
  String toJson() {
    return '{"baseX":$baseX,"baseY":$baseY,"speedX":$speedX,"speedY":$speedY,"level":$level,"type":${type.name},"radius":$radius}';
  }
}

class Base extends MapElement {
  BaseStatus baseStatus;
  bool isProducingBotsPermanently;
  Widget get widget => Container(
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
          );
  Base({required baseX, required baseY, required level, required this.baseStatus, required this.isProducingBotsPermanently}) : super(baseX: baseX, baseY: baseY, speedX: 0, speedY: 0, level: level, type: Types.base, radius: 20);
}

class Bot extends MapElement {
  bool isAIInstalled;
  bool isWeaponInstalled;
  bool isToCaptureBases;
  bool isToDestroyEnemies;
  MapElement? target;
//  static const Color botColor = Colors.grey;
  Bot({required baseX, required baseY, required speedX, required speedY, required this.isAIInstalled, required this.isWeaponInstalled, required this.isToCaptureBases, required this.isToDestroyEnemies, required level}) : super(baseX: baseX, baseY: baseY, speedX: botSpeed, speedY: botSpeed, level: 1, type: Types.mybot, radius: 10);
}

class MyBot extends Bot {
  static const Color botColor = Colors.green;
  Widget get widget => Container(
            width: 10,
            height: 10,
            color: botColor,
          );
  MyBot({required baseX, required baseY, required speedX, required speedY, required level}) : super(baseX: baseX, baseY: baseY, speedX: speedX, speedY: speedY, level: level, isAIInstalled: false, isWeaponInstalled: false, isToCaptureBases: false, isToDestroyEnemies: false,);
  
}

class EnemyBot extends Bot {
  static Color botColor = Colors.red;
  Widget get widget => Container(
            width: 10,
            height: 10,
            color: botColor,
          );
  EnemyBot({required baseX, required baseY, required speedX, required speedY, required level}) : super(baseX: baseX, baseY: baseY, speedX: speedX, speedY: speedY, level: level, isAIInstalled: false, isWeaponInstalled: false, isToCaptureBases: false, isToDestroyEnemies: false,);
}

class Rocket extends MapElement {
  MapElement bot;
  bool isCollided = false;
  Widget get widget => Container(
          width: 2,
          height: 2,
          color: Colors.blue,
        );
  Rocket(this.bot) : super(baseX: bot.baseX, baseY: bot.baseY, speedX: 0, speedY: 0, level: 1, type: Types.rocket, radius: 2);
}


enum Types {wall, base, mybot, enemybot, rocket}
enum BaseStatus {neutral, mine, enemies}