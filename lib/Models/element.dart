import 'package:commander/globals.dart';
import 'package:commander/helpers.dart';
import 'package:flutter/material.dart';

class MapElement {
  num baseX, baseY;
  num speedX, speedY;
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
  @override
  String toString() {
    return 'Base($baseX, $baseY, $level, $baseStatus, $isProducingBotsPermanently)';
    //return super.toString();
  }
}

class Bot extends MapElement {
  bool isAIInstalled;
  bool isWeaponInstalled;
  bool isToCaptureBases;
  bool isToDestroyEnemies;
  Base? captureTarget;
  Bot? shootTarget;
//  static const Color botColor = Colors.grey;
  Bot({required baseX, required baseY, required speedX, required speedY, required this.isAIInstalled, required this.isWeaponInstalled, required this.isToCaptureBases, required this.isToDestroyEnemies, required level}) : super(baseX: baseX, baseY: baseY, speedX: botSpeed, speedY: botSpeed, level: 1, type: Types.mybot, radius: 10);
}

class MyBot extends Bot {
  static const Color botColor = Colors.green;
  Widget get widget => Container(
            width: 10,
            height: 10,
            //color: botColor,
            decoration: BoxDecoration(
              color: botColor,
              border: Border.all(
                color: Colors.black,
                width: 1.0
              )
            )
          );
  MyBot({required baseX, required baseY, required speedX, required speedY, required level}) : super(baseX: baseX, baseY: baseY, speedX: speedX, speedY: speedY, level: level, isAIInstalled: false, isWeaponInstalled: false, isToCaptureBases: false, isToDestroyEnemies: false,);
  @override
  String toString() {
    return 'MyBot($baseX, $baseY, $speedX, $speedY, $level, $isAIInstalled, $isWeaponInstalled, $isToCaptureBases, $isToDestroyEnemies)';
  }
}

class EnemyBot extends Bot {
  static Color botColor = Colors.red;
  Widget get widget => Container(
            width: 10,
            height: 10,
            color: botColor,
          );
  EnemyBot({required super.baseX, required super.baseY, required super.speedX, required super.speedY, required super.level}) : super(isAIInstalled: false, isWeaponInstalled: false, isToCaptureBases: false, isToDestroyEnemies: false);
  @override
  String toString() {
    return 'EnemyBot($baseX, $baseY, $speedX, $speedY, $level, $isAIInstalled, $isWeaponInstalled, $isToCaptureBases, $isToDestroyEnemies)';
  }
}

class Rocket extends MapElement {
  Bot botShooter;
  Bot botTarget;
  bool isCollided = false;
  Widget get widget => Container(
          width: 3,
          height: 3,
          color: Colors.blue,
        );
  Rocket({required this.botShooter, required this.botTarget}) : super(baseX: botShooter.baseX, baseY: botShooter.baseY, speedX: 1, speedY: 0, level: 1, type: Types.rocket, radius: 2);
}


enum Types {wall, base, mybot, enemybot, rocket}
enum BaseStatus {neutral, mine, enemies}