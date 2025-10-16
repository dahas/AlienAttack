import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../core/my_game.dart';
import '../core/sound_manager.dart';
import '../core/sprite_manager.dart';
import 'bullet.dart';
import 'explosion.dart';
import 'missile.dart';

class Enemy extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks {
  final VoidCallback? onEnemyRemoved;
  final int speed;
  final bool straight;
  final int value;

  Enemy({this.onEnemyRemoved, this.speed = 100, this.straight = true, this.value = 25}) : super(size: Vector2.all(50), priority: 10);

  final random = Random();
  static const spriteHeight = 50.0;
  late double direction;

  double time = 0;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    direction = Random().nextBool() ? 1 : -1;

    animation = SpriteManager.enemyAnimation;

    add(RectangleHitbox());

    if (random.nextDouble() < 0.3) {
      final rocket = Missile()
        ..position = Vector2(position.x, position.y + 30);
      game.add(rocket);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!straight) {
      time += dt;
      position.x += sin(time * 2) * 50 * dt * direction;
    }

    position.y += speed * dt;

    if (position.y > game.size.y + Enemy.spriteHeight) {
      removeFromParent();
      onEnemyRemoved?.call();
    }
  }

  @override
  Future<void> onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) async {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      removeFromParent();
      other.removeFromParent();
      game.score += value;
      game.add(Explosion(position: position, size: Vector2.all(60)));
      SoundManager.playExplosionEnemy();
      onEnemyRemoved?.call();
    }
  }
}