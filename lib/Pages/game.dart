import 'dart:async';
import 'package:commander/Models/element.dart';
import 'package:commander/Pages/base.dart';
import 'package:commander/Pages/mybot.dart';
import 'package:commander/Pages/start.dart';
import 'package:commander/Updates/enemybots.dart';
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
  int get enemyBasesCount => heap.where((element) => element is Base && element.baseStatus == BaseStatus.enemies).length;

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
            child: InkWell(
              onTap: () {
                //print('inside');
                //targetElement = e;
                //target = Offset(e.baseX, e.baseY);
                if (e.baseStatus == BaseStatus.mine) Navigator.of(context).push(MaterialPageRoute(builder: (context) => BasePage(base: e)));
              },
              child: e.widget) ,)),
          ...heap.whereType<MyBot>().map((e) => Positioned(
            left: e.baseX - e.radius / 2,
            top: e.baseY - e.radius / 2,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyBotPage(bot: e)));
              },
              child: e.widget) ,)),
          ...heap.whereType<MyBot>().where((bot) => bot.shootTargetRocket != null).map((e) => Positioned(
            left: e.shootTargetRocket!.baseX - e.shootTargetRocket!.radius / 2,
            top: e.shootTargetRocket!.baseY - e.shootTargetRocket!.radius / 2,
            child: e.shootTargetRocket!.widget ,)),
          ...heap.whereType<EnemyBot>().map((e) => Positioned(
            left: e.baseX - e.radius / 2,
            top: e.baseY - e.radius / 2,
            child: e.widget ,)),
          ...heap.whereType<EnemyBot>().where((bot) => bot.shootTargetRocket != null).map((e) => Positioned(
            left: e.shootTargetRocket!.baseX - e.shootTargetRocket!.radius / 2,
            top: e.shootTargetRocket!.baseY - e.shootTargetRocket!.radius / 2,
            child: e.shootTargetRocket!.widget ,)),
          //player status line at bottom of screen
          statusWidget()
        ],
      )),
    );
  }
  
  update() {
    //check for win
    //print('check for win');
    if (myBasesCount == heap.where((element) => element.type == Types.base).length) {
      timer?.cancel();
      print('win');
      //make alert dialog with win data
      var winAlert = AlertDialog(
        title: const Text('You win! Congratulations!'),
        content: Text('Time to win: ${ticks * 1/100} sec.'),
        actions: [
          ElevatedButton(onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const StartPage()));
          }, child: const Text('Ok'))
        ],
      );
      showDialog(context: context, builder: (context) => winAlert);
      return;
    }
    //calculate blocks income
    myBlocks += (myBasesCount / 5000);
    enemyBlocks += (enemyBasesCount / 5000);

    //update my bots movement
    //myBotsUpdate();
    heap.whereType<MyBot>().forEach((element) {
      element.update();
    });

    //update enemy bots movement
    //enemyBotsUpdate();
    heap.whereType<EnemyBot>().forEach((element) {
      element.update();
    });
    createEnemyBots();

    //shooting logic
    //check if my bot is close to enemy bot
    //addToShootingMap();
    //shooting();
    //updateRockets();

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
        height: 30,
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Blocks: ${myBlocks.ceil()} / ${enemyBlocks.ceil()}'),
            Text('Bots: ${heap.whereType<MyBot>().length} / ${heap.whereType<EnemyBot>().length}'),
            Text('Captured Bases: $myBasesCount / ${heap.whereType<Base>().length}'),
            //Text('All bases: ${heap.where((element) => element.type == Types.base).length}'),
          ],
        ),
      ),
    );
  }
}
