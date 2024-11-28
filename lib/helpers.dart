import 'dart:math';
import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';
import 'package:flutter/material.dart';

MapElement? findNearestBase({required MapElement forBot}) {
  MapElement? nearestBase;
  double nearestDistance = double.infinity;
  for (MapElement base in heap.where((element) => element is Base && (element.baseStatus != (forBot is MyBot ? BaseStatus.mine : BaseStatus.enemies)) && !botsTargetsMap.values.contains(element))) {
    double distance = sqrt(pow(base.baseX - forBot.baseX, 2) + pow(base.baseY - forBot.baseY, 2));
    if (distance < nearestDistance) {
      nearestDistance = distance;
      nearestBase = base;
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