import 'dart:math';
import 'dart:async';
import 'package:flame/components.dart';
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
    for (int i = 0; i < remainingEnemies; i++) {
      final x = _rand.nextDouble() * game.size.x;
      final y = -50.0 - _rand.nextDouble() * 200;
      final enemy = Enemy()
        ..position = Vector2(x, y)
        // ..onDestroyed = () => onEnemyDestroyed()
      ;
      game.add(enemy);
    }
  }

  void onEnemyDestroyed() {
    remainingEnemies--;
    game.levelManager.onEnemyDestroyed();
  }
}
