import 'package:flame/components.dart';
import '../components/boss_enemy.dart';
import 'enemy_spawner.dart';
import '../main.dart';

class LevelManager extends Component with HasGameReference<AlienAttack> {
  int currentLevel = 1;
  late EnemySpawner spawner;
  bool bossSpawned = false;

  LevelManager();

  void startLevel(int level) {
    currentLevel = level;
    bossSpawned = false;

    spawner = EnemySpawner(level: level);
    game.add(spawner);
  }

  void onEnemyDestroyed() {
    // Prüfen, ob alle Gegner weg sind
    if (spawner.remainingEnemies == 0 && !bossSpawned) {
      spawnBoss();
    }
  }

  void spawnBoss() {
    bossSpawned = true;
    final boss = BossEnemy();
    game.add(boss);
    print("Boss erscheint!");
  }

  void onBossDefeated() {
    print("Boss besiegt!");
    startLevel(currentLevel + 1);
  }
}
