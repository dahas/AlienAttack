import 'dart:math';
import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flame/extensions.dart';
import 'package:flame/parallax.dart';

void main() {
  runApp(
    GameWidget(
      game: MyGame(),
    ),
  );
}

class MyGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late Player player;

  @override
  Future<void> onLoad() async {
    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      baseVelocity: Vector2(0, -4),
      repeat: ImageRepeat.repeatY,
      fill: LayerFill.width,
      velocityMultiplierDelta: Vector2(0, 2),
    );
    add(parallax);
    player = Player();
    add(player);
    add(
      SpawnComponent(
        factory: (index) {
          return Enemy();
        },
        period: 1,
        area: Rectangle.fromLTWH(40, 0, size.x-80, 0),
        random: Random()
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.move(dt);
    player.shoot(dt);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    player.moveLeft = keysPressed.contains(LogicalKeyboardKey.keyA);
    player.moveRight = keysPressed.contains(LogicalKeyboardKey.keyD);
    player.moveUp = keysPressed.contains(LogicalKeyboardKey.keyW);
    player.moveDown = keysPressed.contains(LogicalKeyboardKey.keyS);
    player.shooting = keysPressed.contains(LogicalKeyboardKey.space);
    return KeyEventResult.handled;
  }
}

class Player extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks {
  Player() :
        super(size: Vector2(50, 100), anchor: Anchor.center);

  bool moveLeft = false;
  bool moveRight = false;
  bool moveUp = false;
  bool moveDown = false;

  bool shooting = false;
  bool isInvincible = false;

  double speed = 300;
  double fireCooldown = 0;

  @override
  Future<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: .1,
        textureSize: Vector2(803, 1280),
      ),
    );

    position = game.size / 2;

    add(CircleHitbox());
  }

  void move(double dt) {
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
    if (shooting && fireCooldown <= 0) {
      final bullet = Bullet()
        ..position = Vector2(playerPos.x, playerPos.y - 50); // Starte am Player
      game.add(bullet);

      fireCooldown = 0.1;
    }
  }

  void startInvincibility() {
    isInvincible = true;
    final blinkEffect = SequenceEffect(
      [
        OpacityEffect.to(0.2, EffectController(duration: 0.15)),
        OpacityEffect.to(1.0, EffectController(duration: 0.15)),
      ],
      infinite: true,
    );

    add(blinkEffect);

    Future.delayed(const Duration(seconds: 2), () {
      isInvincible = false;
      blinkEffect.removeFromParent();
      opacity = 1.0;
    });
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (isInvincible) return;
    super.onCollisionStart(intersectionPoints, other);
    removeFromParent();
    game.add(PlayerExplosion(position: position));
  }
}

class PlayerExplosion extends SpriteAnimationComponent with HasGameReference<MyGame> {
  PlayerExplosion({super.position})
      : super(size: Vector2.all(120), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {

    animation = await game.loadSpriteAnimation(
      'explosion.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        loop: false,
        stepTime: .1,
        textureSize: Vector2(320, 320),
      ),
    );

    animationTicker?.onComplete = respawn;
  }

  void respawn() {
    removeFromParent();
    final player = game.player;
    player.position = Vector2(game.size.x/2, game.size.y/2);
    player.startInvincibility();
    game.add(player);
  }
}

class Bullet extends CircleComponent with HasGameReference<MyGame>, CollisionCallbacks {
  Bullet()
      : super(
    radius: 5,
    paint: Paint()..color = const Color(0xFFFFA600),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * -500;

    if (position.y < -game.size.y/2) {
      removeFromParent();
    }
  }
}

class Enemy extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks {
  Enemy() :
    super(size: Vector2.all(50));

  static const spriteHeight = 50.0;
  final int speed = 100;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    animation = await game.loadSpriteAnimation(
      'enemy.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        loop: true,
        stepTime: .3,
        textureSize: Vector2(483, 483),
      ),
    );

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * speed;

    if (position.y > game.size.y + Enemy.spriteHeight) {
      removeFromParent();
    }
  }

  @override
  Future<void> onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) async {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      removeFromParent();
      other.removeFromParent();
      game.add(EnemyExplosion(position: position));
    }
  }
}

class EnemyExplosion extends SpriteAnimationComponent with HasGameReference<MyGame> {
  EnemyExplosion({super.position})
      : super(size: Vector2.all(60), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {

    animation = await game.loadSpriteAnimation(
      'explosion.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        loop: false,
        stepTime: .1,
        textureSize: Vector2(320, 320),
      ),
    );

    animationTicker?.onComplete = removeFromParent;
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * 40;
  }
}

