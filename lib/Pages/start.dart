import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/Pages/game.dart';
import 'package:commander/assets/maps/maps.dart';
import 'package:commander/globals.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  int basesCount = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          children: [
            Text('How many bases: $basesCount'),
            Slider(
              value: basesCount.toDouble(),
              min: 10,
              max: 100,
              label: 'How many bases',
              onChanged: (x) {
                setState(() {
                  basesCount = x.round();
                });
              }
            ),
            Text('Bots speed: $botSpeed'),
            Slider(
              value: botSpeed,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              label: 'Bots speed',
              onChanged: (x) {
                setState(() {
                  botSpeed = x;
                });
              }
            ),
            TextButton(onPressed: () {
              //start game
              //load map
              heap.clear();
              List<MapElement> elements = List.generate(basesCount, (i) {
                double x = Random().nextDouble() * MediaQuery.of(context).size.width;
                double y = Random().nextDouble() * MediaQuery.of(context).size.height;
                return Base(baseX: x, baseY: y, level: 1, baseStatus: BaseStatus.neutral, isProducingBotsPermanently: false);
              });
              heap.addAll(elements);
              heap.add(mybot);
              MapElement enemybot = EnemyBot(baseX: MediaQuery.of(context).size.width - 50, baseY: MediaQuery.of(context).size.height - 50, speedX: botSpeed, speedY: botSpeed, level: 1);
              heap.add(enemybot);
            
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Game()));
            }, child: const Text('Start game')),
          ],
        ),
      ),
    );
  }
}