import 'dart:async';
import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';
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
      body: SafeArea(child: GestureDetector(
        onTapDown: (details) {
          print(details.localPosition);
          print(center);
          target = targetElement != null ? Offset(targetElement!.baseX, targetElement!.baseY) : details.localPosition;
          movingCenter = center;
        },
        child: Stack(
          children: [
            Container(color: Colors.white,),
            IconButton(
              onPressed: () {
                timer?.cancel();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.stop)
            ),
            ...heap.map((e) => Positioned(
              left: e.baseX - e.radius / 2,
              top: e.baseY - e.radius / 2,
              child: TapRegion(
                onTapInside: (event) {
                  print('inside');
                  targetElement = e;
                  target = Offset(e.baseX, e.baseY);
                },
                child: widgetOfElement(e)) ,)),
            centerPointWidget()],
        ),
      )),
    );
  }
  
  void update() {
    //start moving to target and stop when reached
    //if target is null, do nothing
    //if (targetElement != null) target = Offset(targetElement!.baseX, targetElement!.baseY);
    //if target is not null, move to target
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
            targetElement!.baseStatus = BaseStatus.mine;
          }
          targetElement = null;
        }
      }
    }
    //calculate blocks income
    int myBasesCount = heap.takeWhile((e) => e.baseStatus == BaseStatus.mine).length;
    myBlocks += (myBasesCount / 10);
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
        return Container(
          width: e.radius.toDouble(),
          height: e.radius.toDouble(),
          //color: Colors.white,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0
            )
          ),
        );
      case Types.mybot:
        return Container(
          width: e.radius.toDouble(),
          height: e.radius.toDouble(),
          color: Colors.green,
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
}