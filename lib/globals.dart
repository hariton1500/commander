import 'package:commander/Models/element.dart';

List<MapElement> heap = [];

double myBlocks = 1;
double enemyBlocks = 1;
double botSpeed = 0.1;
double rocketSpeed = 0.5;
double fireDistance = 150;

Map<MyBot, EnemyBot> shootingMyBotEnemyBotMap = {};
Map<EnemyBot, MyBot> shootingEnemyBotMyBotMap = {};
Map<MyBot, Base> captureMyBotsTargetsMap = {};
Map<EnemyBot, Base> captureEnemybotsTargetsMap = {};
Map<MyBot, Rocket> rocketsMyBotsMap = {};
Map<EnemyBot, Rocket> rocketsEnemyBotsMap = {};
