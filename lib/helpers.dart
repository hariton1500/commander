import 'dart:math';

import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';

MapElement? findNearestBase(double baseX, double baseY) {
  MapElement? nearestBase;
  double nearestDistance = double.infinity;
  for (MapElement base in heap.where((element) => element.type == Types.base && element.baseStatus != BaseStatus.mine)) {
    double distance = sqrt(pow(base.baseX - baseX, 2) + pow(base.baseY - baseY, 2));
    if (distance < nearestDistance) {
      nearestDistance = distance;
      nearestBase = base;
    }
  }
  return nearestBase;
}
