import 'dart:async';
import 'package:flame/components.dart';
import '../main.dart';

class EnemySpawner extends Component with HasGameReference<AlienAttack> {
  final int level;
  int remainingEnemies = 0;

  EnemySpawner({required this.level});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Anzahl Gegner pro Level z. B. 5 + Level * 3
    remainingEnemies = 5 + level * 3;

    spawnWave(5);
  }

  void spawnWave(int amount) {
    // game.add(SpawnComponent(
    //   factory: (index) {
    //     return Enemy();
    //   },
    //   period: 1,
    //   area: Rectangle.fromLTWH(40, 0, game.size.x - 80, 0),
    //   random: _rand,
    //   spawnCount: amount,
    // ));
  }

  void onEnemyDestroyed() {
    remainingEnemies--;
    // game.levelManager.onEnemyDestroyed();
  }
}
