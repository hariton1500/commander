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
              //heap = List.generate(5, (index) => MapElement(0, 0, 0, 0, 0, Types.wall).loadFromFile('assets/maps/map$index.json'));
              heap.clear();
              //heap = [maps0, maps1, maps2, maps3, maps4, maps5, maps6, maps7, maps8, maps9, maps10, maps11, maps12, maps13];
              List<MapElement> elements = List.generate(basesCount, (i) {
                double x = Random().nextDouble() * MediaQuery.of(context).size.width;
                double y = Random().nextDouble() * MediaQuery.of(context).size.height;
                return MapElement(x, y, 0, 0, 1, Types.base, 20, BaseStatus.neutral, false, false, false, false, false, x, y);
              });
              heap.addAll(elements);
              heap.add(maps13);
              MapElement enemybot = MapElement(MediaQuery.of(context).size.width - 50, MediaQuery.of(context).size.height - 50, 0, 0, 1, Types.enemybot, 10, BaseStatus.neutral, true, true, false, false, false, MediaQuery.of(context).size.width - 50, MediaQuery.of(context).size.height - 50);
              heap.add(enemybot);
            
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Game()));
            }, child: const Text('Start game')),
          ],
        ),
      ),
    );
  }
}