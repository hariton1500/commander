import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';
import 'package:commander/helpers.dart';

enemyBotsUpdate() {
  heap.whereType<EnemyBot>().forEach((enemybot) {
    //hind target for bot whose target is null
    if (enemybot.isToCaptureBases && enemybot.captureTarget == null) {
      print('start find base to capture for bot ${enemybot.hashCode}');
      //find nearest base
      Base? nearestBase = (!captureEnemybotsTargetsMap.containsKey(enemybot) ? findNearestNotEnemyBase(forBot: enemybot) : null);
      //if nearestBase != null set target to nearest base
      if (nearestBase != null) {
        enemybot.captureTarget = nearestBase;
        //enemybot.targetY = nearestBase.baseY;
        captureEnemybotsTargetsMap[enemybot] = nearestBase;
      }
      //set isToCaptureBases to false
      //mybot.isToCaptureBases = false;
    }
    //update bots movements if it has target
    if (enemybot.captureTarget != null) {
      if (enemybot.baseX.round() != enemybot.captureTarget!.baseX.round() || enemybot.baseY.round() != enemybot.captureTarget!.baseY.round()) {
        //print('enemy bot target is ${enemybot.target}, ${enemybot.target}');
        //calculate distance to target
        //double distance = sqrt(pow(enemybot.baseX - enemybot.target!.baseX, 2) + pow(enemybot.baseY - enemybot.target!.baseY, 2));
        //calculate angle to target
        double angle = atan2(enemybot.captureTarget!.baseY - enemybot.baseY, enemybot.captureTarget!.baseX - enemybot.baseX);
        //calculate speed
        double speed = botSpeed;
        //calculate dx and dy
        double dx = cos(angle) * speed;
        double dy = sin(angle) * speed;
        //move bot
        enemybot.baseX += dx;
        enemybot.baseY += dy;
      } else {
        //set target base status to captured
        captureEnemybotsTargetsMap[enemybot]?.baseStatus = BaseStatus.enemies;
        //remove bot from botsTargetsMap
        captureEnemybotsTargetsMap.remove(enemybot);
        enemybot.captureTarget = null;
      }
    }
  });

}

int get enemyBasesCount => heap.where((element) => element is Base && element.baseStatus == BaseStatus.enemies).length;
createEnemyBots() {
  if (enemyBlocks >= 1 && enemyBasesCount > 0) {
    var enemyBase = heap.whereType<Base>().firstWhere((element) => element.baseStatus == BaseStatus.enemies);
    EnemyBot enemyBot = EnemyBot(baseX: enemyBase.baseX, baseY: enemyBase.baseY, speedX: 0, speedY: 0, level: 3);
    enemyBot.isAIInstalled = false;
    enemyBot.isToCaptureBases = true;
    enemyBot.isToDestroyEnemies = true;
    enemyBot.isWeaponInstalled = true;
    heap.add(enemyBot);
    enemyBlocks -= 2;
  }
}