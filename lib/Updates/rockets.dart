
import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';

//update rockets movements function
void updateRockets() {
  List<MapElement> toDelete = [];
  for (var rocket in heap.whereType<Rocket>()) {
    if (rocket.baseX < 0 || rocket.baseX > 1000 || rocket.baseY < 0 || rocket.baseY > 1000) {
      //heap.remove(rocket);
      toDelete.add(rocket);
      rocket.botShooter.shootTarget = null;
      rocketsMyBotsMap.remove(rocket.botShooter);
      rocketsEnemyBotsMap.remove(rocket.botShooter);
    } else {
      //update rocket position
      //calculate angle to target
      double angle = atan2(rocket.botTarget.baseY - rocket.baseY, rocket.botTarget.baseX - rocket.baseX);
      //calculate speed
      double speed = rocketSpeed;
      //calculate dx and dy
      double dx = cos(angle) * speed;
      double dy = sin(angle) * speed;
      //move rocket
      rocket.baseX += dx;
      rocket.baseY += dy;
      //check if rocket is close to target
      if (sqrt(pow(rocket.baseX - rocket.botTarget.baseX, 2) + pow(rocket.baseY - rocket.botTarget.baseY, 2)) < 1) {
        //remove rocket from heap
        toDelete.add(rocket);
        //heap.remove(rocket);
        //remove rocket from maps
        rocket.botShooter.shootTarget = null;
        shootingMyBotEnemyBotMap.remove(rocket.botShooter);
        shootingEnemyBotMyBotMap.remove(rocket.botShooter);
        captureEnemybotsTargetsMap.remove(rocket.botShooter);
        captureMyBotsTargetsMap.remove(rocket.botShooter);
        rocketsMyBotsMap.remove(rocket.botShooter);
        rocketsEnemyBotsMap.remove(rocket.botShooter);
        //destroy bot target
        toDelete.add(rocket.botTarget);
        //heap.remove(rocket.botTarget);
        
      }
    }
  }
  for (var element in toDelete) {
    heap.remove(element);
  }
  toDelete.clear();
}
