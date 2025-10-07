import 'dart:math';
import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../main.dart';

class BossEnemy extends SpriteComponent with HasGameReference<AlienAttack>, CollisionCallbacks {
  double hp = 500;
  double speed = 40;
  bool entering = true;

  BossEnemy() : super(size: Vector2(200, 120));

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('boss.png');
    position = Vector2(game.size.x / 2 - size.x / 2, -size.y);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (entering) {
      position.y += speed * dt;
      if (position.y > 100) entering = false;
    } else {
      // Einfaches horizontales Pendeln
      position.x += sin(game.elapsedTime() * 2) * speed * dt;
    }
  }

  void takeDamage(double dmg) {
    hp -= dmg;
    if (hp <= 0) {
      removeFromParent();
      game.levelManager.onBossDefeated();
    }
  }
}
