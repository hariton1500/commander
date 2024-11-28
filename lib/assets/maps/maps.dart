import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';

/*
MapElement maps0 = MapElement(0, 100, 0, 0, 1, Types.wall, 10, BaseStatus.neutral, false, false, false, false, false, 0, 0);
MapElement maps1 = MapElement(10, 100, 0, 0, 1, Types.wall, 10, BaseStatus.neutral, false, false, false, false, false, 0, 0);
MapElement maps2 = MapElement(20, 100, 0, 0, 1, Types.wall, 10, BaseStatus.neutral, false, false, false, false, false, 0, 0);
MapElement maps3 = MapElement(30, 100, 0, 0, 1, Types.wall, 10, BaseStatus.neutral, false, false, false, false, false, 0, 0);
MapElement maps4 = MapElement(40, 100, 0, 0, 1, Types.wall, 10, BaseStatus.neutral, false, false, false, false, false, 0, 0);
MapElement maps5 = MapElement(50, 100, 0, 0, 1, Types.wall, 10, BaseStatus.neutral, false, false, false, false, false, 0, 0);
MapElement maps6 = MapElement(60, 100, 0, 0, 1, Types.wall, 10, BaseStatus.neutral, false, false, false, false, false, 0, 0);
MapElement maps7 = MapElement(70, 100, 0, 0, 1, Types.wall, 10, BaseStatus.neutral, false, false, false, false, false, 0, 0);
MapElement maps8 = MapElement(80, 100, 0, 0, 1, Types.wall, 10, BaseStatus.neutral, false, false, false, false, false, 0, 0);
MapElement maps9 = MapElement(90, 100, 0, 0, 1, Types.wall, 10, BaseStatus.neutral, false, false, false, false, false, 0, 0);*/
//add 3 bases
//MapElement maps10 = MapElement(baseX: 100, 150, 0, 0, 1, Types.base, 20, BaseStatus.neutral, false, false, false, false, false, 0, 0);
//MapElement maps11 = MapElement(110, 200, 0, 0, 1, Types.base, 20, BaseStatus.neutral, false, false, false, false, false, 0, 0);
//MapElement maps12 = MapElement(120, 60, 0, 0, 1, Types.base, 20, BaseStatus.neutral, false, false, false, false, false, 0, 0);
//add 1 mybot
MapElement mybot = MyBot(baseX: 50, baseY: 50, speedX: botSpeed, speedY: botSpeed, level: 1);
