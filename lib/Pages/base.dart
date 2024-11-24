import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Building blocks: ${myBlocks.ceil()}'),
            const SizedBox(height: 50,),
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
                        if (myBlocks >= 1) {
                          isAIInstalled = true;
                          myBlocks -= 1;
                        }
                      } else {
                        //uninstall AI
                        isAIInstalled = false;
                        myBlocks += 1;
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
                        if (myBlocks >= 1) {
                          isWeaponInstalled = true;
                          myBlocks -= 1;
                        }
                      } else {
                        //uninstall weapon
                        isWeaponInstalled = false;
                        myBlocks += 1;
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
                        if (myBlocks >= 1) {
                          isEngineInstalled = true;
                          myBlocks -= 1;
                        }
                      } else {
                        //uninstall engine
                        isEngineInstalled = false;
                        myBlocks += 1;
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
            ))
          ],
        ),
      ),
    );
  }
}