import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import '../main.dart';

class EnemySpawner extends Component with HasGameReference<AlienAttack> {
  final int level;
  int remainingEnemies = 0;
  final Random _rand = Random();

  EnemySpawner({required this.level});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Anzahl Gegner pro Level z. B. 5 + Level * 3
    remainingEnemies = 5 + level * 3;

    spawnWave();
  }

  void spawnWave() {
    game.add(SpawnComponent(
      factory: (index) {
        return Enemy();
      },
      period: 1,
      area: Rectangle.fromLTWH(40, 0, game.size.x - 80, 0),
      random: _rand,
    ));
  }

  void onEnemyDestroyed() {
    remainingEnemies--;
    game.levelManager.onEnemyDestroyed();
  }
}
