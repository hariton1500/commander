import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';

shooting() {
  //add rockets to heap if it doesnt exist
  for (var bot in shootingMyBotEnemyBotMap.keys) {
    if (rocketsMyBotsMap.keys.contains(bot)) {
      //rocketsMap[bot]!.update();
      if (/*rocketsMap[bot]!.isCollided*/true) {
        rocketsMyBotsMap.remove(bot);
      }
    } else {
      rocketsMyBotsMap[bot] = Rocket(bot);
      heap.add(rocketsMyBotsMap[bot]!);
    }
  }
  //update rockets movement and check for collision

}

