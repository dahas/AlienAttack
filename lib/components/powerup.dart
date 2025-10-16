import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:alien_attack/components/player.dart';

import '../core/my_game.dart';
import '../core/sound_manager.dart';

class PowerUp extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks {
  int? type;

  PowerUp({this.type}) : super(size: Vector2(50, 50), anchor: Anchor.center, priority: 10);

  double speedY = 50;
  double horizontalSpeed = 0;
  double targetSpeed = 0;
  double driftTimer = 0;
  double driftDuration = 2;
  double time = 0;

  final random = Random();

  late String image;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    switch(type) {
      case 1: image = 'powerup1.png'; break;
      case 2: image = 'powerup2.png'; break;
      default: image = 'powerup3.png';break;
    }

    animation = await game.loadSpriteAnimation(
      image,
      SpriteAnimationData.sequenced(
        amount: 5,
        loop: true,
        stepTime: .1,
        textureSize: Vector2(120, 120),
      ),
    );

    add(
      CircleHitbox(),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    time += dt;
    driftTimer += dt;

    if (driftTimer >= driftDuration) {
      driftTimer = 0;
      driftDuration = 1 + random.nextDouble() * 3; // 1–4 s
      targetSpeed = (random.nextBool() ? 1 : -1) * (50 + random.nextDouble() * 100);
    }

    horizontalSpeed = lerpDouble(horizontalSpeed, targetSpeed, dt * 2)!;

    position.x += horizontalSpeed * dt;
    position.y += sin(time * 0.8) * 10 * dt + speedY * dt;

    if (position.x < size.x / 2) {
      position.x = size.x / 2;
      horizontalSpeed = horizontalSpeed.abs();
      targetSpeed = horizontalSpeed;
    } else if (position.x > game.size.x - size.x / 2) {
      position.x = game.size.x - size.x / 2;
      horizontalSpeed = -horizontalSpeed.abs();
      targetSpeed = horizontalSpeed;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      removeFromParent();
      switch(type) {
        case 1: SoundManager.playPowerUp1(); break;
        case 2: SoundManager.playPowerUp2(); break;
        default: SoundManager.playPowerUp3(); break;
      }
    }
  }
}