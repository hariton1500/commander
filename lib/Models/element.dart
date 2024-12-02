import 'dart:math';

import 'package:commander/globals.dart';
import 'package:commander/helpers.dart';
import 'package:flutter/material.dart';

class MapElement {
  num baseX, baseY;
  Offset get place => Offset(baseX.toDouble(), baseY.toDouble()); 
  num speedX, speedY;
  Offset get speed => Offset(speedX.toDouble(), speedY.toDouble());
  int level;
  Types type;
  int radius;

  void update() {}

  void moveTo(MapElement target) {
    double angle = atan2(target.baseY - baseY, target.baseX - baseX);
    baseX += cos(angle) * speedX;
    baseY += sin(angle) * speedY;
  }
  
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
  Rocket? shootTargetRocket;
//  static const Color botColor = Colors.grey;
  Bot({required baseX, required baseY, required speedX, required speedY, required this.isAIInstalled, required this.isWeaponInstalled, required this.isToCaptureBases, required this.isToDestroyEnemies, required level}) : super(baseX: baseX, baseY: baseY, speedX: botSpeed, speedY: botSpeed, level: 1, type: Types.mybot, radius: 10);
  
  void destroy() {
    heap.remove(this);
  }
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
  MyBot({required super.baseX, required super.baseY, required super.speedX, required super.speedY, required super.level}) : super(isAIInstalled: false, isWeaponInstalled: false, isToCaptureBases: false, isToDestroyEnemies: false,);
  @override
  String toString() {
    return 'MyBot($baseX, $baseY, $speedX, $speedY, $level, $isAIInstalled, $isWeaponInstalled, $isToCaptureBases, $isToDestroyEnemies)';
  }

  @override
  void update() {
    //movements
    if (isToCaptureBases) {
      //find nearest base to capture it
      captureTarget ??= findNearestNotMyBase(forBot: this);
      //if target is found, move to it
      if (captureTarget != null) {
        //check if bot reached target
        if (distance(this, captureTarget!) < 2) {
          //set base status to captured
          captureTarget!.baseStatus = BaseStatus.mine;
          //set target to null
          captureTarget = null;
        } else {
          //move to target
          moveTo(captureTarget!);
        }
      }
    }
    //start fire
    if (isToDestroyEnemies) {
      //if not shooting, start shooting
      if (shootTarget == null) {
        //find enemy bot to shoot in range
        shootTarget ??= findEnemyBotInRange(forBot: this, range: fireDistance);
        //if target is found, start shooting
        if (shootTarget != null) {
          //fire a rocket
          shootTargetRocket = Rocket(botShooter: this, botTarget: shootTarget!);
          //add rocket to heap
          //heap.add(shootTargetRocket!);
        }
      }
    }
    //update rocket position
    if (shootTargetRocket != null) {
      //update rocket position
      shootTargetRocket!.update();
      //if rocket reached target, destroy target
      if ((shootTargetRocket!.place - shootTarget!.place).distance < 1.0) {
        //destroy target
        shootTarget!.destroy();
        //set target to null
        shootTarget = null;
        //set rocket to null
        shootTargetRocket = null;
      }
    }
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

  @override
  void update() {
    //movements
    if (isToCaptureBases) {
      //find nearest base to capture it
      captureTarget ??= findNearestNotEnemyBase(forBot: this);
      //if target is found, move to it
      if (captureTarget != null) {
        //check if bot reached target
        if (distance(this, captureTarget!) < 2) {
          //set base status to captured
          captureTarget!.baseStatus = BaseStatus.enemies;
          //set target to null
          captureTarget = null;
        } else {
          //move to target
          moveTo(captureTarget!);
        }
      }
    }
    //start fire
    if (isToDestroyEnemies) {
      //if not shooting, start shooting
      if (shootTarget == null) {
        //find enemy bot to shoot in range
        shootTarget ??= findMyBotInRange(forBot: this, range: fireDistance);
        //if target is found, start shooting
        if (shootTarget != null) {
          //fire a rocket
          shootTargetRocket = Rocket(botShooter: this, botTarget: shootTarget!);
          //add rocket to heap
          //heap.add(shootTargetRocket!);
        }
      }
    }
    //update rocket position
    if (shootTargetRocket != null) {
      //update rocket position
      shootTargetRocket!.update();
      //if rocket reached target, destroy target
      if ((shootTargetRocket!.place - shootTarget!.place).distance < 1.0) {
        //destroy target
        shootTarget!.destroy();
        //set target to null
        shootTarget = null;
        //set rocket to null
        shootTargetRocket = null;
      }
    }
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