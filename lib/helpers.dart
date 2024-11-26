import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';

MapElement? findNearestBase({required MapElement forBot}) {
  MapElement? nearestBase;
  double nearestDistance = double.infinity;
  for (MapElement base in heap.where((element) => element.type == Types.base && (element.baseStatus != (forBot.type == Types.mybot ? BaseStatus.mine : BaseStatus.enemies)) && !botsTargetsMap.values.contains(element))) {
    double distance = sqrt(pow(base.baseX - forBot.baseX, 2) + pow(base.baseY - forBot.baseY, 2));
    if (distance < nearestDistance) {
      nearestDistance = distance;
      nearestBase = base;
    }
  }
  return nearestBase;
}
