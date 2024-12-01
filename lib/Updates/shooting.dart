import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';

shooting() {
  print('shooting');
  //add rockets to heap if it doesnt exist
  for (var bot in shootingMyBotEnemyBotMap.keys) {
    if (!rocketsMyBotsMap.keys.contains(bot)) {
      rocketsMyBotsMap[bot] = Rocket(botTarget: bot.shootTarget!, botShooter: bot);
      heap.add(rocketsMyBotsMap[bot]!);
    }
  }
  for (var bot in shootingEnemyBotMyBotMap.keys) {
    if (!rocketsEnemyBotsMap.keys.contains(bot)) {
      rocketsEnemyBotsMap[bot] = Rocket(botTarget: bot.target as Bot, botShooter: bot);
      heap.add(rocketsEnemyBotsMap[bot]!);
    }
  }
}

