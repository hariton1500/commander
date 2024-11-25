import 'dart:async';
import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/Pages/base.dart';
import 'package:commander/Pages/mybot.dart';
import 'package:commander/globals.dart';
import 'package:commander/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {

  Timer? timer;
  int ticks = 0;
  int lastBlocksIncomeTick = 0;
  Offset? center, target, movingCenter;
  MapElement? targetElement;
  int get myBasesCount => heap.where((e) => e.baseStatus == BaseStatus.mine).length;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      timer = Timer.periodic(const Duration(milliseconds: 10), (t) {
        ticks++;
        //update
        update();
        //draw
        //check for collision
        //check for win
        //check for lose
        //check for draw
        //check for end of game
        //check for restart
        //check for quit
        setState(() {});
        //print(ticks);
      });
    });
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    center = Offset(MediaQuery.sizeOf(context).width / 2, MediaQuery.sizeOf(context).height / 2);
    return Scaffold(
      body: SafeArea(child: Stack(
        children: [
          Container(color: Colors.white,),
          ...heap.map((e) => Positioned(
            left: e.baseX - e.radius / 2,
            top: e.baseY - e.radius / 2,
            child: TapRegion(
              onTapInside: (event) {
                //print('inside');
                targetElement = e;
                target = Offset(e.baseX, e.baseY);
              },
              child: widgetOfElement(e)) ,)),
          //centerPointWidget(),
          //player status line at bottom of screen
          statusWidget()
        ],
      )),
    );
  }
  
  Future<void> update() async {
    //check for win
    if (myBasesCount == heap.where((element) => element.type == Types.base).length) {
      timer?.cancel();
      print('win');
      return;
    }
    //player moving, actualy moving a map and all on it
    //start moving to target and stop when reached
    //if target is null, do nothing
    /*
    if (target != null) {
      double x = target!.dx - center!.dx;
      double y = target!.dy - center!.dy;
      double angle = atan2(y, x);
      double speed = 1;
      double dx = cos(angle) * speed;
      double dy = sin(angle) * speed;
      movingCenter = Offset(movingCenter!.dx + dx, movingCenter!.dy + dy);
      //print(movingCenter!.direction);
      for (int i = 0; i < heap.length; i++) {
        heap[i].baseX -= dx;
        heap[i].baseY -= dy;
      }
    }
    //if target is reached, set target to null
    if (target != null) {
      if (movingCenter!.dx - target!.dx < 1 && movingCenter!.dy - target!.dy < 1) {
        target = null;
        if (targetElement != null) {
          //we reached element. if it is base open base menu operation
          if (targetElement!.type == Types.base) {
            //targetElement!.baseStatus = BaseStatus.mine;
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) => BasePage(base: targetElement!)));
          }
          targetElement = null;
        }
      }
    }*/
    //calculate blocks income
    myBlocks += (myBasesCount / 5000);

    //update bots movement
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

  widgetOfElement(MapElement e) {
    switch (e.type) {
      case Types.wall:
        return Container(
          width: e.radius.toDouble(),
          height: e.radius.toDouble(),
          //color: Colors.grey,
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(
              color: Colors.green
            )
          ),
        );
      case Types.base:
        return InkWell(
          onTap: () {
            if (e.baseStatus == BaseStatus.mine) Navigator.of(context).push(MaterialPageRoute(builder: (context) => BasePage(base: e)));
          },
          child: Container(
            width: e.radius.toDouble(),
            height: e.radius.toDouble(),
            //color: Colors.white,
            decoration: BoxDecoration(
              color: e.baseStatus == BaseStatus.mine ? Colors.green : Colors.red,
              border: Border.all(
                color: Colors.black,
                width: 2.0
              )
            ),
          ),
        );
      case Types.mybot:
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyBotPage(bot: e)));
          },
          child: Container(
            width: e.radius.toDouble(),
            height: e.radius.toDouble(),
            color: Colors.green,
          ),
        );
      case Types.enemybot:
        return Container(
          width: e.radius.toDouble(),
          height: e.radius.toDouble(),
          color: Colors.red,
        );
    }
  }
  
  centerPointWidget() {
    return Positioned(
      left: center!.dx - 5,
      top: center!.dy - 5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
        width: 10,
        height: 10,
        //color: Colors.red,
      ),
    );
  }
  
  statusWidget() {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: 50,
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Blocks: ${myBlocks.ceil()}'),
            Text('Bots: ${heap.where((element) => element.type == Types.mybot).length}'),
            Text('Captured Bases: $myBasesCount'),
            Text('All bases: ${heap.where((element) => element.type == Types.base).length}'),
          ],
        ),
      ),
    );
  }
}