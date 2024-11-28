import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';

shooting() {
  //add rockets to heap if it doesnt exist
  for (MapElement bot in shootingMyBotEnemyBotMap.keys) {
    if (rocketsMap.keys.contains(bot)) {
      //rocketsMap[bot]!.update();
      if (/*rocketsMap[bot]!.isCollided*/true) {
        rocketsMap.remove(bot);
      }
    } else {
      rocketsMap[bot] = Rocket(bot);
      heap.add(rocketsMap[bot]!);
    }
  }
  //update rockets movement and check for collision

}

