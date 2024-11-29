import 'dart:async';
import 'package:commander/Models/element.dart';
import 'package:commander/Updates/addtoshootingmap.dart';
import 'package:commander/Updates/enemybots.dart';
import 'package:commander/Updates/mybots.dart';
import 'package:commander/Updates/shooting.dart';
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
  int get myBasesCount => heap.where((element) => element is Base && element.baseStatus == BaseStatus.mine).length;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      timer = Timer.periodic(const Duration(milliseconds: 10), (t) {
        ticks++;
        update();
        setState(() {});
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
          ...heap.whereType<Base>().map((e) => Positioned(
            left: e.baseX - e.radius / 2,
            top: e.baseY - e.radius / 2,
            child: TapRegion(
              onTapInside: (event) {
                //print('inside');
                targetElement = e;
                target = Offset(e.baseX, e.baseY);
              },
              child: e.widget) ,)),
          //player status line at bottom of screen
          statusWidget()
        ],
      )),
    );
  }
  
  update() {
    //check for win
    print('check for win');
    if (myBasesCount == heap.where((element) => element.type == Types.base).length) {
      timer?.cancel();
      print('win');
      return;
    }
    //calculate blocks income
    myBlocks += (myBasesCount / 5000);

    //update my bots movement
    myBotsUpdate();

    //update enemy bots movement
    enemyBotsUpdate();

    //shooting logic
    //check if my bot is close to enemy bot
    addToShootingMap();
    shooting();
  }

  /*
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
              color: getColor(e),
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
      case Types.rocket:
        return Container(
          width: e.radius.toDouble(),
          height: e.radius.toDouble(),
          color: Colors.blue,
        );
    }
  }*/
  
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
