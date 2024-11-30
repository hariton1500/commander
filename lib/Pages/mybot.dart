import 'package:commander/Models/element.dart';
import 'package:flutter/material.dart';

class MyBotPage extends StatefulWidget {
  const MyBotPage({super.key, required this.bot});
  final MyBot bot;

  @override
  State<MyBotPage> createState() => _MyBotPageState();
}

class _MyBotPageState extends State<MyBotPage> {
  
  late bool isToCaptureBases, isToDestroyEnemies;

  @override
  void initState() {
    
    super.initState();
    isToCaptureBases = widget.bot.isToCaptureBases;
    isToDestroyEnemies = widget.bot.isToDestroyEnemies;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      //capture bases
                      setState(() {
                        isToCaptureBases = !isToCaptureBases;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isToCaptureBases ? Colors.green : Colors.grey,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0
                        )
                      ),
                      height: 100,
                      width: 100,
                      child: const Center(child: Text('Capture bases'))),
                  ),
                  InkWell(
                    onTap: () {
                      //destroy enemies
                      setState(() {
                        isToDestroyEnemies = !isToDestroyEnemies;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isToDestroyEnemies ? Colors.green : Colors.grey,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0
                        )
                      ),
                      height: 100,
                      width: 100,
                      child: const Center(child: Text('Destroy enemies'))),
                  ),
                ],
            ),
            ElevatedButton(onPressed: () {
              widget.bot.isToCaptureBases = isToCaptureBases;
              widget.bot.isToDestroyEnemies = isToDestroyEnemies;
              Navigator.of(context).pop();
            }, child: const Text('Launch'))
          ],
        ),
      ),
    );
  }
}