import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';
import 'package:commander/helpers.dart';

myBotsUpdate() {
  heap.whereType<MyBot>().forEach((mybot) {
    if (mybot.isToCaptureBases) {
      print('start find base to capture for bot ${mybot.hashCode}');
      //find nearest base
      Base? nearestBase = (!captureMyBotsTargetsMap.containsKey(mybot) ? findNearestNotMyBase(forBot: mybot) : null) as Base?;
      //if nearestBase != null set target to nearest base
      if (nearestBase != null) {
        mybot.target = nearestBase;
        //mybot.targetY = nearestBase.baseY;
        captureMyBotsTargetsMap[mybot] = nearestBase;
      }
      //set isToCaptureBases to false
      //mybot.isToCaptureBases = false;
    }
    print('bot target is ${mybot.target?.baseX}, ${mybot.target?.baseY}');
    //calculate distance to target
    double distance = sqrt(pow(mybot.baseX - mybot.target!.baseX, 2) + pow(mybot.baseY - mybot.target!.baseY, 2));
    //calculate angle to target
    double angle = atan2(mybot.target!.baseY - mybot.baseY, mybot.target!.baseX - mybot.baseX);
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
      (captureMyBotsTargetsMap[mybot] as Base).baseStatus = BaseStatus.mine;
      //remove bot from botsTargetsMap
      captureMyBotsTargetsMap.remove(mybot);
      mybot.isToCaptureBases = true;
    }
  });

}