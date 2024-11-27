import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';
import 'package:commander/helpers.dart';

myBotsUpdate() {
  heap.where((e) => e.type == Types.mybot && e.isToCaptureBases).forEach((mybot) {
    if (mybot.isToCaptureBases) {
      print('start find base to capture for bot ${mybot.hashCode}');
      //find nearest base
      MapElement? nearestBase = !botsTargetsMap.containsKey(mybot) ? findNearestBase(forBot: mybot) : null;
      //if nearestBase != null set target to nearest base
      if (nearestBase != null) {
        mybot.targetX = nearestBase.baseX;
        mybot.targetY = nearestBase.baseY;
        botsTargetsMap[mybot] = nearestBase;
      }
      //set isToCaptureBases to false
      //mybot.isToCaptureBases = false;
    }
    print('bot target is ${mybot.targetX}, ${mybot.targetY}');
    //calculate distance to target
    double distance = sqrt(pow(mybot.baseX - mybot.targetX, 2) + pow(mybot.baseY - mybot.targetY, 2));
    //calculate angle to target
    double angle = atan2(mybot.targetY - mybot.baseY, mybot.targetX - mybot.baseX);
    //calculate speed
    double speed = botSpeed;
    //calculate dx and dy
    double dx = cos(angle) * speed;
    double dy = sin(angle) * speed;
    //move bot
    mybot.baseX += dx;
    mybot.baseY += dy;
    //if bot is close to target, set target to null
    if (distance < 1) {
      print('bot reached target');
      //set target base status to captured
      botsTargetsMap[mybot]?.baseStatus = BaseStatus.mine;
      //remove bot from botsTargetsMap
      botsTargetsMap.remove(mybot);
      mybot.isToCaptureBases = true;
    }
  });

}