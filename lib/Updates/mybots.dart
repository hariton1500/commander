import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';
import 'package:commander/helpers.dart';

myBotsUpdate() {
  heap.whereType<MyBot>().forEach((mybot) {
    //find target for bot whose target is null
    if (mybot.isToCaptureBases && mybot.captureTarget == null) {
      //print('start find base to capture for bot ${mybot.hashCode}');
      //find nearest base
      Base? nearestBase = (!captureMyBotsTargetsMap.containsKey(mybot) ? findNearestNotMyBase(forBot: mybot) : null);
      //if nearestBase != null set target to nearest base
      if (nearestBase != null) {
        mybot.captureTarget = nearestBase;
        //mybot.targetY = nearestBase.baseY;
        captureMyBotsTargetsMap[mybot] = nearestBase;
        print(captureMyBotsTargetsMap);
      }
      //set isToCaptureBases to false
      //mybot.isToCaptureBases = false;
    }
    //update bots movements if it has target
    if (mybot.captureTarget != null) {
      if (mybot.baseX.round() != mybot.captureTarget!.baseX.round() || mybot.baseY.round() != mybot.captureTarget!.baseY.round()) {
        //print('bot target is ${mybot.target?.baseX}, ${mybot.target?.baseY}');
        //calculate distance to target
        //double distance = sqrt(pow(mybot.baseX - mybot.target!.baseX, 2) + pow(mybot.baseY - mybot.target!.baseY, 2));
        //calculate angle to target
        double angle = atan2(mybot.captureTarget!.baseY - mybot.baseY, mybot.captureTarget!.baseX - mybot.baseX);
        //calculate speed
        double speed = botSpeed;
        //calculate dx and dy
        double dx = cos(angle) * speed;
        double dy = sin(angle) * speed;
        //move bot
        mybot.baseX += dx;
        mybot.baseY += dy;
        //if bot is close to target, set target to null
      } else {
        //set target base status to captured
        captureMyBotsTargetsMap[mybot]?.baseStatus = BaseStatus.mine;
        //remove bot from botsTargetsMap
        captureMyBotsTargetsMap.remove(mybot);
        print(captureMyBotsTargetsMap);
        //set target to null
        mybot.captureTarget = null;
      }
    }
  });

}