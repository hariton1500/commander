import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';

addToShootingMap() {
  heap.where((element) => element is MyBot && element.isToDestroyEnemies && element.isWeaponInstalled).forEach((mybot) {
    //if this bot not shooting now find closed enemy bot in range
    if (!shootingMyBotEnemyBotMap.containsKey(mybot)) {
      //find distance to nearest enemy bot
      double nearestDistance = double.infinity;
      EnemyBot? nearestEnemyBot;
      heap.whereType<EnemyBot>().forEach((enemybot) {
        double distance = sqrt(pow(enemybot.baseX - mybot.baseX, 2) + pow(enemybot.baseY - mybot.baseY, 2));
        if (distance < nearestDistance) {
          nearestDistance = distance;
          nearestEnemyBot = enemybot as EnemyBot?;
        }
      });
      //if nearest enemy bot is in range shoot it
      if (nearestEnemyBot != null && nearestDistance < fireDistance) {
        //add to shooting map
        shootingMyBotEnemyBotMap[mybot as MyBot] = nearestEnemyBot!;
        mybot.shootTarget = nearestEnemyBot;
      }
    }
  });
  //do it for enemy bots
  heap.where((element) => element is EnemyBot && element.isToDestroyEnemies && element.isWeaponInstalled).forEach((enemybot) {
    //if this bot not shooting now find closed enemy bot in range
    if (!shootingEnemyBotMyBotMap.containsKey(enemybot)) {
      //find distance to nearest my bot
      double nearestDistance = double.infinity;
      MyBot? nearestMyBot;
      heap.whereType<MyBot>().forEach((mybot) {
        double distance = sqrt(pow(mybot.baseX - enemybot.baseX, 2) + pow(mybot.baseY - enemybot.baseY, 2));
        if (distance < nearestDistance) {
          nearestDistance = distance;
          nearestMyBot = mybot;
        }
      });
      //if nearest enemy bot is in range shoot it
      if (nearestMyBot != null && nearestDistance < fireDistance) {
        //add to shooting map
        shootingEnemyBotMyBotMap[enemybot as EnemyBot] = nearestMyBot!;
        enemybot.shootTarget = nearestMyBot;
      }
    }
  });

}