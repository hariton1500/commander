import 'package:commander/Models/element.dart';

List<MapElement> heap = [];
double myBlocks = 1;
Map<MapElement, MapElement> botsTargetsMap = {}, enemybotsTargetsMap = {}, shootingMyBotEnemyBotMap = {}, shootingEnemyBotMyBotMap = {};
double botSpeed = 0.1;
