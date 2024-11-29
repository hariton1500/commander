import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';
import 'package:commander/helpers.dart';

enemyBotsUpdate() {
  heap.whereType<EnemyBot>().forEach((enemybot) {
    //hind target for bot whose target is null
    if (enemybot.isToCaptureBases && enemybot.target == null) {
      print('start find base to capture for bot ${enemybot.hashCode}');
      //find nearest base
      Base? nearestBase = (!captureEnemybotsTargetsMap.containsKey(enemybot) ? findNearestNotEnemyBase(forBot: enemybot) : null) as Base?;
      //if nearestBase != null set target to nearest base
      if (nearestBase != null) {
        enemybot.target = nearestBase;
        //enemybot.targetY = nearestBase.baseY;
        captureEnemybotsTargetsMap[enemybot] = nearestBase;
      }
      //set isToCaptureBases to false
      //mybot.isToCaptureBases = false;
    }
    //update bots movements if it has target
    if (enemybot.target != null) {
      print('enemy bot target is ${enemybot.target}, ${enemybot.target}');
      //calculate distance to target
      double distance = sqrt(pow(enemybot.baseX - enemybot.target!.baseX, 2) + pow(enemybot.baseY - enemybot.target!.baseY, 2));
      //calculate angle to target
      double angle = atan2(enemybot.target!.baseY - enemybot.baseY, enemybot.target!.baseX - enemybot.baseX);
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
        (captureEnemybotsTargetsMap[enemybot])?.baseStatus = BaseStatus.enemies;
        //remove bot from botsTargetsMap
        captureEnemybotsTargetsMap.remove(enemybot);
        enemybot.isToCaptureBases = true;
      }
    }
  });

}