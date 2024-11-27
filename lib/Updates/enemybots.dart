import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';
import 'package:commander/helpers.dart';

enemyBotsUpdate() {
  heap.where((e) => e.type == Types.enemybot).forEach((enemybot) {
    if (enemybot.isToCaptureBases) {
      print('start find base to capture for bot ${enemybot.hashCode}');
      //find nearest base
      MapElement? nearestBase = !botsTargetsMap.containsKey(enemybot) ? findNearestBase(forBot: enemybot) : null;
      //if nearestBase != null set target to nearest base
      if (nearestBase != null) {
        enemybot.targetX = nearestBase.baseX;
        enemybot.targetY = nearestBase.baseY;
        enemybotsTargetsMap[enemybot] = nearestBase;
      }
      //set isToCaptureBases to false
      //mybot.isToCaptureBases = false;
    }
    print('enemy bot target is ${enemybot.targetX}, ${enemybot.targetY}');
    //calculate distance to target
    double distance = sqrt(pow(enemybot.baseX - enemybot.targetX, 2) + pow(enemybot.baseY - enemybot.targetY, 2));
    //calculate angle to target
    double angle = atan2(enemybot.targetY - enemybot.baseY, enemybot.targetX - enemybot.baseX);
    //calculate speed
    double speed = botSpeed;
    //calculate dx and dy
    double dx = cos(angle) * speed;
    double dy = sin(angle) * speed;
    //move bot
    enemybot.baseX += dx;
    enemybot.baseY += dy;
    //if bot is close to target, set target to null
    if (distance < 1) {
      print('bot reached target');
      //set target base status to captured
      enemybotsTargetsMap[enemybot]?.baseStatus = BaseStatus.enemies;
      //remove bot from botsTargetsMap
      botsTargetsMap.remove(enemybot);
      enemybot.isToCaptureBases = true;
    }
  });

}