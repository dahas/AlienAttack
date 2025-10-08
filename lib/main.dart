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
import 'package:flame/extensions.dart';
import 'package:flame/parallax.dart';
import 'overlays/hud.dart';

void main() {
  runApp(
    GameWidget(
      game: AlienAttack(),
      overlayBuilderMap: {
        'StartMenu': (BuildContext context, AlienAttack game) {
          return Visibility(
            visible: !game.paused,
            child: Center(
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "🚀 Alien Attack 🚀",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Controls:\n\n"
                          "W = up\nA = left\nS = down\nD = right\nSpace = shoot\nP = pause\nEsc = exit\n\n"
                          "Mission: Survive the enemy waves and defeat the final boss!",
                      style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreenAccent.shade400.withValues(alpha: 0.8),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        game.overlays.remove('StartMenu');
                        game.start();
                      },
                      child: const Text(
                        'Play',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          );
        },
        'GameOver': (BuildContext context, AlienAttack game) {
          return Visibility(
            visible: !game.paused,
            child: Center(
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "💥 Game over! 💥",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreenAccent.shade400.withValues(alpha: 0.8),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            game.overlays.remove('GameOver');
                            game.start();
                          },
                          child: const Text(
                            'Try again',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade400.withValues(alpha: 0.8),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            game.overlays.remove('GameOver');
                            game.quit();
                          },
                          child: const Text(
                            'Quit',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          );
        },
        'Paused': (BuildContext context, AlienAttack game) {
          return Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: .6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "☕ Paused ☕",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Press P again to continue ...",
                    style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
                    textAlign: TextAlign.center
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   children: [
                  //     ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.lightGreenAccent.shade400.withValues(alpha: 0.8),
                  //         foregroundColor: Colors.black,
                  //         padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //       ),
                  //       onPressed: () {
                  //         game.overlays.remove('GameOver');
                  //         game.start();
                  //       },
                  //       child: const Text(
                  //         'Try again',
                  //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //     SizedBox(width: 8),
                  //     ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.teal.shade400.withValues(alpha: 0.8),
                  //         foregroundColor: Colors.black,
                  //         padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //       ),
                  //       onPressed: () {
                  //         game.overlays.remove('GameOver');
                  //         game.quit();
                  //       },
                  //       child: const Text(
                  //         'Quit',
                  //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          );
        },
        'StartWave1': (BuildContext context, AlienAttack game) {
          return Visibility(
              visible: !game.paused,
              child: Align(
                alignment: Alignment(0, -.4),
                child: Text(
                  "Prepare for the first strike!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
          );
        },
        'StartWave2': (BuildContext context, AlienAttack game) {
          return Visibility(
              visible: !game.paused,
              child: Align(
                alignment: Alignment(0, -.4),
                child: Text(
                  "Get ready for the second wave!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
          );
        },
        'StartWave3': (BuildContext context, AlienAttack game) {
          return Visibility(
              visible: !game.paused,
              child: Align(
                alignment: Alignment(0, -.4),
                child: Text(
                  "You made them angry. Watch out!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
          );
        },
        'Victory': (BuildContext context, AlienAttack game) {
          return Visibility(
              visible: !game.paused,
              child: Center(
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Congratulation!",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "🏆",
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Well played! You taught them a lesson!",
                        style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreenAccent.shade400.withValues(alpha: 0.8),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              game.overlays.remove('Victory');
                              game.start();
                            },
                            child: const Text(
                              'New game',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade400.withValues(alpha: 0.8),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              game.overlays.remove('Victory');
                              game.quit();
                            },
                            child: const Text(
                              'Quit',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          );
        },
      },
    ),
  );
}

class AlienAttack extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late Player player;
  late SpawnComponent enemySpawner;

  int starsCollected = 0;
  int lifes = 3;
  bool started = false;
  int currentWave = 0;
  int spawnCount = 0;
  double wavePauseTimer = 0;
  bool inWavePause = false;

  double time = 0;

  @override
  Future<void> onLoad() async {
    await images.loadAll([ // Preload and cache images
      'player.png',
      'bullet.png',
      'enemy.png',
      'life_lost.png',
      'life.png',
      'star.png',
      'explosion.png',
      'stars_0.png',
      'stars_1.png',
      'stars_2.png',
      'missile1.png',
    ]);

    player = Player();

    overlays.add("StartMenu");

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

    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewport.add(Hud());
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.move(dt);
    player.shoot(dt);

    if(started) time += dt;

    if (inWavePause) {
      wavePauseTimer -= dt;
      if (wavePauseTimer <= 0) {
        inWavePause = false;
        startWave();
      }
    }
  }

  void start() {
    started = true;
    starsCollected = 0;
    lifes = 3;
    currentWave = 0;
    spawnCount = 0;
    wavePauseTimer = 0;
    inWavePause = false;

    clear(); // Reset Enemies, Bullets, etc.

    player.position = Vector2(size.x / 2, size.y - 100);
    if (!player.isMounted) add(player);

    startWave();
  }

  void startWave() {
    currentWave++;
    spawnCount = 0;

    if (currentWave == 1) {
      overlays.add("StartWave1");
      Future.delayed(const Duration(seconds: 2), () {
        overlays.remove("StartWave1");
        spawnCount = 10;
        enemySpawner = SpawnComponent(
          factory: (index) {
            if(index >= spawnCount-1) onSpawnFinished();
            return EnemyAlpha(onEnemyRemoved: onSpawnFinished, speed: 100);
          },
          period: 1,
          area: Rectangle.fromLTWH(40, 0, size.x - 80, 0),
          random: Random(),
          spawnCount: spawnCount,
        );
        add(enemySpawner);
      });
    }

    if (currentWave == 2) {
      overlays.add("StartWave2");
      Future.delayed(const Duration(seconds: 2), () {
        overlays.remove("StartWave2");
        spawnCount = 18;
        enemySpawner = SpawnComponent(
          factory: (index) {
            return EnemyAlpha(onEnemyRemoved: onSpawnFinished, speed: 150);
          },
          period: .8,
          area: Rectangle.fromLTWH(40, 0, size.x - 80, 0),
          random: Random(),
          spawnCount: spawnCount,
        );
        add(enemySpawner);
      });
    }

    if (currentWave == 3) {
      overlays.add("StartWave3");
      Future.delayed(const Duration(seconds: 2), () {
        overlays.remove("StartWave3");
        spawnCount = 24;
        enemySpawner = SpawnComponent(
          factory: (index) {
            return EnemyAlpha(onEnemyRemoved: onSpawnFinished, speed: 200);
          },
          period: .6,
          area: Rectangle.fromLTWH(40, 0, size.x - 80, 0),
          random: Random(),
          spawnCount: spawnCount,
        );
        add(enemySpawner);
      });
    }

    if (currentWave == 4) {
      overlays.add("Victory");
    }
  }

  void onSpawnFinished() {
    spawnCount--;
    if (spawnCount <= 0) {
      enemySpawner.removeFromParent();
      inWavePause = true;
      wavePauseTimer = 3;
    }
  }

  void quit() {
    started = false;
    starsCollected = 0;
    lifes = 3;

    clear();

    overlays.add("StartMenu");
  }

  void clear() {
    final toRemove = children.where((component) =>
      component is EnemyAlpha ||
      component is PlayerBullet ||
      component is SpawnComponent ||
      component is EnemyMissile1 ||
      component is Player
    ).toList();

    for (final c in toRemove) {
      c.removeFromParent();
    }
  }

  void pause() {
    paused = !paused; // Toggle
    if(paused) {
      overlays.add("Paused");
    } else {
      overlays.remove("Paused");
    }
  }

  double elapsedTime() {
    return time;
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    player.moveLeft = keysPressed.contains(LogicalKeyboardKey.keyA);
    player.moveRight = keysPressed.contains(LogicalKeyboardKey.keyD);
    player.moveUp = keysPressed.contains(LogicalKeyboardKey.keyW);
    player.moveDown = keysPressed.contains(LogicalKeyboardKey.keyS);
    player.shooting = keysPressed.contains(LogicalKeyboardKey.space);

    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.keyP)) {
        pause();
      }
      if (keysPressed.contains(LogicalKeyboardKey.escape)) {
        quit();
      }
    }

    return KeyEventResult.handled;
  }
}

class Player extends SpriteAnimationComponent with HasGameReference<AlienAttack>, CollisionCallbacks {
  Player() :
        super(size: Vector2(50, 80), anchor: Anchor.center);

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

    position = Vector2(game.size.x / 2, game.size.y - 100);

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
      final bullet = PlayerBullet()
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

    game.lifes--;
  }
}

class PlayerExplosion extends SpriteAnimationComponent with HasGameReference<AlienAttack> {
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
    if(game.lifes > 0) {
      final player = game.player;
      player.position = Vector2(game.size.x/2, game.size.y/2);
      player.startInvincibility();
      game.add(player);
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        game.started = false;
        game.overlays.add("GameOver");
      });
    }
  }
}

class PlayerBullet extends SpriteAnimationComponent with HasGameReference<AlienAttack>, CollisionCallbacks {
  PlayerBullet() : super(size: Vector2(20, 35), anchor: Anchor.center);

  final speed = 400;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    animation = await game.loadSpriteAnimation(
      'bullet.png',
      SpriteAnimationData.sequenced(
        amount: 5,
        loop: true,
        stepTime: .1,
        textureSize: Vector2(35, 68),
      ),
    );

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

    if (position.y < 0) {
      removeFromParent();
    }
  }
}

class EnemyAlpha extends SpriteAnimationComponent with HasGameReference<AlienAttack>, CollisionCallbacks {
  final VoidCallback onEnemyRemoved;
  final int speed;

  EnemyAlpha({required this.onEnemyRemoved, this.speed = 100}) : super(size: Vector2.all(50));

  final random = Random();

  static const spriteHeight = 50.0;

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

    if (random.nextDouble() < 0.3) {
      final rocket = EnemyMissile1()
        ..position = Vector2(position.x, position.y + 30);
      game.add(rocket);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * speed;

    if (position.y > game.size.y + EnemyAlpha.spriteHeight) {
      removeFromParent();
      onEnemyRemoved();
    }
  }

  @override
  Future<void> onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) async {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerBullet) {
      removeFromParent();
      other.removeFromParent();
      game.add(EnemyExplosion(position: position));
      onEnemyRemoved();
    }
  }
}

class EnemyExplosion extends SpriteAnimationComponent with HasGameReference<AlienAttack> {
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

class EnemyMissile1 extends SpriteAnimationComponent with HasGameReference<AlienAttack>, CollisionCallbacks {
  EnemyMissile1() : super(size: Vector2(25, 50), anchor: Anchor.center);

  final speed = 400;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    animation = await game.loadSpriteAnimation(
      'missile1.png',
      SpriteAnimationData.sequenced(
        amount: 5,
        loop: true,
        stepTime: .1,
        textureSize: Vector2(100, 375),
      ),
    );

    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y -= dt * -speed;

    if (position.y > game.size.y) {
      removeFromParent();
    }
  }
}