import 'dart:math';
import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';
import 'package:flutter/material.dart';

double distance(MapElement a, MapElement b) {
  return (a.place - b.place).distance;
  //return sqrt(pow(a.baseX - b.baseX, 2) + pow(a.baseY - b.baseY, 2));
}

EnemyBot? findEnemyBotInRange({required MyBot forBot, required double range}) {
  return heap.whereType<EnemyBot>().where((bot) => (forBot.place - bot.place).distance <= range).firstOrNull;
}

MyBot? findMyBotInRange({required EnemyBot forBot, required double range}) {
  return heap.whereType<MyBot>().where((bot) => (forBot.place - bot.place).distance <= range).firstOrNull;
}

Base? findNearestNotMyBase({required MyBot forBot}) {
  Base? nearestBase;
  double nearestDistance = double.infinity;
  for (MapElement element in heap.where((element) => element is Base && element.baseStatus != BaseStatus.mine && !captureMyBotsTargetsMap.values.contains(element))) {
    double distance = sqrt(pow(element.baseX - forBot.baseX, 2) + pow(element.baseY - forBot.baseY, 2));
    if (distance < nearestDistance) {
      nearestDistance = distance;
      nearestBase = element as Base?;
    }
  }
  return nearestBase;
}

Base? findNearestNotEnemyBase({required EnemyBot forBot}) {
  Base? nearestBase;
  double nearestDistance = double.infinity;
  for (MapElement element in heap.where((element) => element is Base && element.baseStatus != BaseStatus.enemies && !captureEnemybotsTargetsMap.values.contains(element))) {
    double distance = sqrt(pow(element.baseX - forBot.baseX, 2) + pow(element.baseY - forBot.baseY, 2));
    if (distance < nearestDistance) {
      nearestDistance = distance;
      nearestBase = element as Base?;
    }
  }
  return nearestBase;
}


Color getColor(BaseStatus status) {
  switch (status) {
    case BaseStatus.mine:
      return Colors.green;
    case BaseStatus.enemies:
      return Colors.red;
    case BaseStatus.neutral:
      return Colors.grey;
  }
}