import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';
import 'package:commander/helpers.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key, required this.base});
  final MapElement base;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {

  bool isEngineInstalled = false;
  bool isWeaponInstalled = false;
  bool isAIInstalled = false;
  bool isToCaptureBases = true;
  bool isToDestroyEnemies = true;
  bool isProducingBotsPermanently = false;
  int blocksLimit = myBlocks.ceil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.base.type.name}: constructing bots'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Building blocks: ${blocksLimit.ceil()}'),
            //const SizedBox(height: 10,),
            Container(
              //we need to construct a robot here by installing modules like engine, weapon, AI.
              width: 100,
              height: 304,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      if (!isAIInstalled) {
                        //check if we have enough blocks to install AI
                        if (blocksLimit >= 1) {
                          isAIInstalled = true;
                          blocksLimit -= 1;
                        }
                      } else {
                        //uninstall AI
                        isAIInstalled = false;
                        blocksLimit += 1;
                      }
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isAIInstalled ? Colors.green : Colors.grey,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0
                        )
                      ),
                      height: 100,
                      width: 100,
                      child: const Center(child: Text('AI'))),
                  ),
                  InkWell(
                    onTap: () {
                      if (!isWeaponInstalled) {
                        //check if we have enough blocks to install weapon
                        if (blocksLimit >= 1) {
                          isWeaponInstalled = true;
                          blocksLimit -= 1;
                        }
                      } else {
                        //uninstall weapon
                        isWeaponInstalled = false;
                        blocksLimit += 1;
                      }
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isWeaponInstalled ? Colors.green : Colors.grey,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0
                        )
                      ),
                      height: 100,
                      width: 100,
                      child: const Center(child: Text('Weapon'))),
                  ),
                  InkWell(
                    onTap: () {
                      if (!isEngineInstalled) {
                        //check if we have enough blocks to install engine
                        if (blocksLimit >= 1) {
                          isEngineInstalled = true;
                          blocksLimit -= 1;
                        }
                      } else {
                        //uninstall engine
                        isEngineInstalled = false;
                        blocksLimit += 1;
                      }
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isEngineInstalled ? Colors.green : Colors.grey,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0
                        )
                      ),
                      height: 100,
                      width: 100,
                      child: const Center(child: Text('Engine'))),
                  ),
                ],
              )
            ),
            const SizedBox(height: 50,),
            //choose a missions for your robot, like capture bases, destroy enemies
            if (isAIInstalled) Container(
              width: 204,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            )),
            //const SizedBox(height: 20,),
            //check if we want to produce bots permanently
            if (isEngineInstalled) SizedBox(
              width: 300,
              child: CheckboxListTile(value: isProducingBotsPermanently, onChanged: (value) {
                setState(() {
                  isProducingBotsPermanently = value!;
                });
              },
              title: const Text('Produce bots permanently'),
              dense: true,
              ),
            ),
            //button to start producing bots
            if (isEngineInstalled) ElevatedButton(onPressed: () {
              //launch the robots production
              int level = (isAIInstalled ? 1 : 0) + (isWeaponInstalled ? 1 : 0) + 1;
              MyBot bot = MyBot(baseX: widget.base.baseX, baseY: widget.base.baseY, speedX: 0, speedY: 0, level: 1);
              //if isCaptureBases is true, then we want to find nearest neutral or enemy base and set it as target
              if (isToCaptureBases) {
                //find nearest neutral or enemy base
                MapElement? nearestBase = findNearestBase(forBot: bot);
                if (nearestBase != null && nearestBase is Base) {
                  //set target
                  bot.target = nearestBase;
                  //bot.targetY = nearestBase.baseY;
                }
              }
              heap.add(bot);
              myBlocks -= level;
              Navigator.of(context).pop();
            },
            child: const Text('Launch')),

          ],
        ),
      ),
    );
  }
}

