import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';

addToShootingMap() {
  heap.where((e) => e.type == Types.mybot).forEach((mybot) {
    //if this bot not shooting now find closed enemy bot in range 50
    if (!shootingMyBotEnemyBotMap.containsKey(mybot)) {
      //find distance to nearest enemy bot
      double nearestDistance = double.infinity;
      MapElement? nearestEnemyBot;
      heap.where((e) => e.type == Types.enemybot).forEach((enemybot) {
        double distance = sqrt(pow(enemybot.baseX - mybot.baseX, 2) + pow(enemybot.baseY - mybot.baseY, 2));
        if (distance < nearestDistance) {
          nearestDistance = distance;
          nearestEnemyBot = enemybot;
        }
      });
      //if nearest enemy bot is in range 50 shoot it
      if (nearestEnemyBot != null && nearestDistance < 50) {
        //add to shooting map
        shootingMyBotEnemyBotMap[mybot] = nearestEnemyBot!;
      }
    }
  });
  //do it for enemy bots
  heap.where((e) => e.type == Types.enemybot).forEach((enemybot) {
    //if this bot not shooting now find closed enemy bot in range 50
    if (!shootingEnemyBotMyBotMap.containsKey(enemybot)) {
      //find distance to nearest my bot
      double nearestDistance = double.infinity;
      MapElement? nearestMyBot;
      heap.where((e) => e.type == Types.mybot).forEach((mybot) {
        double distance = sqrt(pow(mybot.baseX - enemybot.baseX, 2) + pow(mybot.baseY - enemybot.baseY, 2));
        if (distance < nearestDistance) {
          nearestDistance = distance;
          nearestMyBot = mybot;
        }
      });
      //if nearest enemy bot is in range 50 shoot it
      if (nearestMyBot != null && nearestDistance < 50) {
        //add to shooting map
        shootingEnemyBotMyBotMap[enemybot] = nearestMyBot!;
      }
    }
  });

}