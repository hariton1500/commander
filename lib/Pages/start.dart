import 'package:commander/Pages/game.dart';
import 'package:commander/assets/maps/maps.dart';
import 'package:commander/globals.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: TextButton(onPressed: () {
          //start game
          //load map
          //heap = List.generate(5, (index) => MapElement(0, 0, 0, 0, 0, Types.wall).loadFromFile('assets/maps/map$index.json'));
          heap.clear();
          heap = [maps0, maps1, maps2, maps3, maps4, maps5, maps6, maps7, maps8, maps9, maps10, maps11, maps12, maps13];


          Navigator.push(context, MaterialPageRoute(builder: (context) => const Game()));
        }, child: const Text('Start game')),
      ),
    );
  }
}