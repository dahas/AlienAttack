import 'dart:async';
import 'package:alien_attack/components/powerup.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import '../core/my_game.dart';
import '../core/sound_manager.dart';
import 'asteroid.dart';
import 'bullet.dart';
import 'explosion.dart';

class Player extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks {
  Player() :
        super(size: Vector2(50, 80), anchor: Anchor.center, priority: 10);

  bool moveLeft = false;
  bool moveRight = false;
  bool moveUp = false;
  bool moveDown = false;

  bool shooting = false;
  bool isInvisible = false;
  bool isProtected = false;

  double speed = 300;
  double fireCooldown = 0;

  Vector2 previousPosition = Vector2.zero();

  int shootingPower = 1;

  @override
  Future<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: .1,
        textureSize: Vector2(110, 175),
      ),
    );

    position = Vector2(game.size.x / 2, game.size.y - 300);

    add(CircleHitbox());
  }

  @override
  void render(Canvas canvas) {
    if (isInvisible) return;
    super.render(canvas);
  }

  void move(double dt) {
    previousPosition = position.clone();
    if (moveLeft) {
      if(position.x >= 30) {
        position.x -= speed * dt;
      }
    }
    if (moveRight) {
      if(position.x < game.size.x - 30) {
        position.x += speed * dt;
      }
    }
    if (moveUp) {
      if(position.y >= 60) {
        position.y -= speed * dt;
      }
    }
    if (moveDown) {
      if(position.y < game.size.y -60) {
        position.y += speed * dt;
      }
    }
  }

  void shoot(double dt) {
    fireCooldown -= dt;
    final playerPos = position.clone();
    if (shooting && fireCooldown <= 0 && !isInvisible) {
      switch(shootingPower) {
        case 1:
          final bulletC = Bullet(direction: Vector2(0, -1), speed: 400);
          bulletC.position = Vector2(playerPos.x, playerPos.y - 50);
          game.add(bulletC);
          fireCooldown = .5;
          break;
        case 2:
          final bulletC = Bullet(direction: Vector2(0, -1), speed: 500);
          bulletC.position = Vector2(playerPos.x, playerPos.y - 50);
          game.add(bulletC);
          fireCooldown = .3;
          break;
        case 3:
          final bulletL = Bullet(direction: Vector2(0, -1), speed: 550);
          final bulletR = Bullet(direction: Vector2(0, -1), speed: 550);
          bulletL.position = Vector2(playerPos.x-10, playerPos.y - 30);
          bulletR.position = Vector2(playerPos.x+10, playerPos.y - 30);
          game.add(bulletL);
          game.add(bulletR);
          fireCooldown = .2;
          break;
        default:
          final bulletL = Bullet(direction: Vector2(-.05, -1), speed: 600);
          final bulletC = Bullet(direction: Vector2(0, -1), speed: 600);
          final bulletR = Bullet(direction: Vector2(.05, -1), speed: 600);
          bulletL.position = Vector2(playerPos.x-10, playerPos.y - 20);
          bulletC.position = Vector2(playerPos.x, playerPos.y - 50);
          bulletR.position = Vector2(playerPos.x+10, playerPos.y - 20);
          game.add(bulletL);
          game.add(bulletC);
          game.add(bulletR);
          fireCooldown = .1;
          break;
      }
    }
  }

  void startInvincibility() {
    isProtected = true;
    final blinkEffect = SequenceEffect(
      [
        OpacityEffect.to(0.2, EffectController(duration: 0.15)),
        OpacityEffect.to(1.0, EffectController(duration: 0.15)),
      ],
      infinite: true,
    );

    add(blinkEffect);

    Future.delayed(const Duration(seconds: 2), () {
      isProtected = false;
      blinkEffect.removeFromParent();
      opacity = 1.0;
    });
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if(other is Asteroid) {
      position = Vector2(previousPosition.x, previousPosition.y + 20);
    } else if(other is PowerUp) {
      shootingPower++;
    } else if(other is! Bullet) {
      if (isProtected || isInvisible) return;
      game.add(Explosion(position: position, size: Vector2.all(120)));
      game.lifes--;
      game.score -= 100;
      SoundManager.playExplosionPlayer();
      respawn();
    }
  }

  void respawn() {
    isInvisible = true;
    Future.delayed(const Duration(seconds: 2), () {
      if(game.lifes > 0) {
        isInvisible = false;
        startInvincibility();
      } else {
        game.over();
      }
    });
  }
}