import 'dart:math';
import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flame/extensions.dart';
import 'package:flame/parallax.dart';
import 'core/sound_manager.dart';
import 'overlays/hud.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
                      "🛸",
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "ALIEN ATTACK",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Your mission: Survive the enemy waves and defeat the final boss!",
                      style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Controls:\n\n"
                          "WASD = steer\nSpace = shoot\n"
                          "P = pause\nEsc = exit\n\n"
                          "Or use Mouse/Finger",
                      style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
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
                  "Ready?",
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
                  "Not bad!",
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
                  "They are not amused!",
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
        'StartWave4': (BuildContext context, AlienAttack game) {
          return Visibility(
              visible: !game.paused,
              child: Align(
                alignment: Alignment(0, -.4),
                child: Text(
                  "They called mommy!",
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
                        "Well played!\nYou taught them a lesson!",
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

class AlienAttack extends FlameGame with KeyboardEvents, PanDetector, HasCollisionDetection {
  late Player player;

  Vector2? dragStartFinger;
  Vector2? dragStartPlayer;

  final int testProgress = 0;

  late SpawnComponent enemyAlphaSpawner;
  late SpawnComponent enemyBetaSpawner;
  late SpawnComponent powerupSpawner;
  late SpawnComponent astroidSpawner;

  int score = 0;
  int lifes = 3;
  bool started = false;
  int currentWave = 0;
  int spawnCount = 0;
  double wavePauseTimer = 0;
  bool inWavePause = false;

  double time = 0;

  late Sprite? bulletSprite;
  late Sprite? asteroid1Sprite;
  late Sprite? asteroid2Sprite;
  late Sprite? asteroid3Sprite;
  late Sprite? asteroid4Sprite;
  late Sprite? asteroid5Sprite;
  late Sprite? fireballSprite;

  late SpriteAnimation enemyAnimation;
  late SpriteAnimation sandburstAnimation;

  @override
  Future<void> onLoad() async {
    await SoundManager.init();

    await images.loadAll([
      'player.png',
      'bullet.png',
      'enemy.png',
      'life_lost.png',
      'life.png',
      'explosion.png',
      'sandburst.png',
      'stars_0.png',
      'stars_1.png',
      'stars_2.png',
      'missile1.png',
      'asteroid1.png',
      'asteroid2.png',
      'asteroid3.png',
      'asteroid4.png',
      'asteroid5.png',
      'powerup1.png',
      'powerup2.png',
      'powerup3.png',
      'boss_shadow.png',
      'boss.png',
      'fireball.png',
    ]);

    bulletSprite = Sprite(images.fromCache("bullet.png"));
    asteroid1Sprite = Sprite(images.fromCache("asteroid1.png"));
    asteroid2Sprite = Sprite(images.fromCache("asteroid2.png"));
    asteroid3Sprite = Sprite(images.fromCache("asteroid3.png"));
    asteroid4Sprite = Sprite(images.fromCache("asteroid4.png"));
    asteroid5Sprite = Sprite(images.fromCache("asteroid5.png"));
    fireballSprite = Sprite(images.fromCache("fireball.png"));

    enemyAnimation = await loadSpriteAnimation(
      'enemy.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        loop: true,
        stepTime: .3,
        textureSize: Vector2(483, 483),
      ),
    );

    sandburstAnimation = await loadSpriteAnimation(
      'sandburst.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        loop: false,
        stepTime: .1,
        textureSize: Vector2(50, 50),
      ),
    );

    player = Player();

    overlays.add("StartMenu");

    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      priority: 0,
      baseVelocity: Vector2(0, -4),
      repeat: ImageRepeat.repeatY,
      fill: LayerFill.width,
      velocityMultiplierDelta: Vector2(0, 2),
    );
    add(parallax);

    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewport.removeWhere((c) => c is Hud); // Remove!
    camera.viewport.add(Hud());
  }

  @override
  void onPanStart(DragStartInfo info) {
    if(!started) return;
    dragStartFinger = info.eventPosition.global.clone();
    dragStartPlayer = player.position.clone();
    player.shooting = true;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (dragStartFinger == null || dragStartPlayer == null) return;

    final currentFinger = info.eventPosition.global;
    final delta = currentFinger - dragStartFinger!;
    player.position = dragStartPlayer! + delta;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    dragStartFinger = null;
    dragStartPlayer = null;
    player.shooting = false;
  }

  @override
  void onPanCancel() {
    dragStartFinger = null;
    dragStartPlayer = null;
    player.shooting = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (lifes > 0) {
      player.move(dt);
      player.shoot(dt);
    }

    if(started) time += dt;

    if (inWavePause) {
      wavePauseTimer -= dt;
      if (wavePauseTimer <= 0) {
        inWavePause = false;
        if (lifes > 0) {
          startWave();
        }
      }
    }
  }

  void start() {
    started = true;
    score = 0;
    lifes = 3;
    currentWave = 0 + testProgress;
    spawnCount = 0;
    wavePauseTimer = 0;
    inWavePause = false;

    SoundManager.playBackgroundMusic();

    clear(); // Reset Enemies, Bullets, etc.

    player.position = Vector2(size.x / 2, size.y - 100);
    player.shootingPower = 1 + testProgress;
    player.isInvisible = false;
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
        spawnCount = 20;
        enemyAlphaSpawner = SpawnComponent(
          factory: (index) {
            if(index >= spawnCount-1) onSpawnFinished();
            return EnemyAlpha(onEnemyRemoved: onSpawnFinished, speed: 200, value: 25);
          },
          period: 1,
          area: Rectangle.fromLTWH(40, 0, size.x - 80, 0),
          random: Random(),
          spawnCount: spawnCount,
        );
        add(enemyAlphaSpawner);
        powerupSpawner = SpawnComponent(
          factory: (index) => PowerUp(type: 1),
          period: 3,
          area: Rectangle.fromLTWH(200, 0, size.x - 200, 0),
          random: Random(),
          spawnCount: 1,
        );
        add(powerupSpawner);
      });
    }

    if (currentWave == 2) {
      overlays.add("StartWave2");
      Future.delayed(const Duration(seconds: 2), () {
        overlays.remove("StartWave2");
        spawnCount = 30;
        enemyAlphaSpawner = SpawnComponent(
          factory: (index) {
            return EnemyAlpha(onEnemyRemoved: onSpawnFinished, speed: 250, straight: false, value: 50);
          },
          period: .7,
          area: Rectangle.fromLTWH(40, 0, size.x - 80, 0),
          random: Random(),
          spawnCount: spawnCount,
        );
        add(enemyAlphaSpawner);
        astroidSpawner = SpawnComponent(
          factory: (i) {
            final random = Random().nextDouble();
            final randomX = random * size.x;
            final dir = Vector2(random*2-1, 1); // nach unten
            final speed = 30 + Random().nextDouble() * 60;
            return Asteroid(speed: speed, direction: dir)
              ..position = Vector2(randomX, -50);
          },
          period: 5,
          area: Rectangle.fromLTWH(0, 0, size.x, 0),
          random: Random(),
          spawnCount: 7,
        );
        add(astroidSpawner);
        powerupSpawner = SpawnComponent(
          factory: (index) => PowerUp(type: 2),
          period: 3,
          area: Rectangle.fromLTWH(100, 0, size.x - 100, 0),
          random: Random(),
          spawnCount: 1,
        );
        add(powerupSpawner);
      });
    }

    if (currentWave == 3) {
      overlays.add("StartWave3");
      Future.delayed(const Duration(seconds: 2), () {
        overlays.remove("StartWave3");
        spawnCount = 50;
        enemyAlphaSpawner = SpawnComponent(
          factory: (index) {
            return EnemyAlpha(onEnemyRemoved: onSpawnFinished, speed: 300, straight: false, value: 75);
          },
          period: .4,
          area: Rectangle.fromLTWH(40, 0, size.x - 80, 0),
          random: Random(),
          spawnCount: spawnCount,
        );
        add(enemyAlphaSpawner);
        astroidSpawner = SpawnComponent(
          factory: (i) {
            final random = Random().nextDouble();
            final randomX = random * size.x;
            final dir = Vector2(random*2-1, 1); // nach unten
            final speed = 40 + Random().nextDouble() * 60;
            return Asteroid(speed: speed, direction: dir)
              ..position = Vector2(randomX, -50);
          },
          period: 4,
          area: Rectangle.fromLTWH(0, 0, size.x, 0),
          random: Random(),
          spawnCount: 10,
        );
        add(astroidSpawner);
        powerupSpawner = SpawnComponent(
          factory: (index) => PowerUp(type: 3),
          period: 3,
          area: Rectangle.fromLTWH(100, 0, size.x - 100, 0),
          random: Random(),
          spawnCount: 1,
        );
        add(powerupSpawner);
      });
    }

    if (currentWave == 4) {
      overlays.add("StartWave4");
      Future.delayed(const Duration(seconds: 2), () {
        overlays.remove("StartWave4");
        spawnCount = 70;
        enemyAlphaSpawner = SpawnComponent(
          factory: (index) {
            return EnemyAlpha(speed: 300, straight: false);
          },
          period: .4,
          area: Rectangle.fromLTWH(40, 0, size.x - 80, 0),
          random: Random(),
          spawnCount: spawnCount,
        );
        add(enemyAlphaSpawner);
        astroidSpawner = SpawnComponent(
          factory: (i) {
            final random = Random().nextDouble();
            final randomX = random * size.x;
            final dir = Vector2(random*2-1, 1); // nach unten
            final speed = 40 + Random().nextDouble() * 60;
            return Asteroid(speed: speed, direction: dir)
              ..position = Vector2(randomX, -50);
          },
          period: 4,
          area: Rectangle.fromLTWH(0, 0, size.x, 0),
          random: Random(),
          spawnCount: 20,
        );
        add(astroidSpawner);
        final intro = BossIntro(
          onIntroComplete: (Vector2 pos, double scale) {
            final boss = Boss(onBossRemoved: onSpawnFinished)
              ..position = pos
              ..scale = Vector2.all(scale)
              ..anchor = Anchor.center;
            add(boss);
          },
        );

        add(intro);
      });
    }

    if (currentWave >= 5) {
      if(lifes > 0) {
        overlays.add("Victory");
      }
    }
  }

  void onSpawnFinished() {
    spawnCount--;
    if (spawnCount <= 0) {
      enemyAlphaSpawner.removeFromParent();
      inWavePause = true;
      wavePauseTimer = 3;
    }
  }

  void over() {
    started = false;
    overlays.add("GameOver");
  }

  void clear() {
    final toRemove = children.where((component) =>
      component is EnemyAlpha ||
      component is PlayerBullet ||
      component is SpawnComponent ||
      component is EnemyMissile1 ||
      component is Asteroid ||
      component is PowerUp ||
      component is Boss ||
      component is Fireball
    ).toList();

    player.isInvisible = true;

    for (final c in toRemove) {
      c.removeFromParent();
    }

    overlays.remove("GameOver");
    overlays.remove("Victory");
  }

  void pause() {
    paused = !paused; // Toggle
    if(paused) {
      FlameAudio.bgm.pause();
      overlays.add("Paused");
    } else {
      FlameAudio.bgm.resume();
      overlays.remove("Paused");
    }
  }

  void quit() {
    clear();
    overlays.add("StartMenu");
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

  @override
  void onDispose() {
    SoundManager.dispose();

    bulletSprite = null;
    asteroid1Sprite = null;
    asteroid2Sprite = null;
    asteroid3Sprite = null;
    asteroid4Sprite = null;
    asteroid5Sprite = null;
    fireballSprite = null;

    super.onDispose();
  }
}

class Player extends SpriteAnimationComponent with HasGameReference<AlienAttack>, CollisionCallbacks {
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
          final bulletC = PlayerBullet(direction: Vector2(0, -1), speed: 400);
          bulletC.position = Vector2(playerPos.x, playerPos.y - 50);
          game.add(bulletC);
          fireCooldown = .5;
          break;
        case 2:
          final bulletC = PlayerBullet(direction: Vector2(0, -1), speed: 500);
          bulletC.position = Vector2(playerPos.x, playerPos.y - 50);
          game.add(bulletC);
          fireCooldown = .3;
          break;
        case 3:
          final bulletL = PlayerBullet(direction: Vector2(0, -1), speed: 550);
          final bulletR = PlayerBullet(direction: Vector2(0, -1), speed: 550);
          bulletL.position = Vector2(playerPos.x-10, playerPos.y - 30);
          bulletR.position = Vector2(playerPos.x+10, playerPos.y - 30);
          game.add(bulletL);
          game.add(bulletR);
          fireCooldown = .2;
          break;
        default:
          final bulletL = PlayerBullet(direction: Vector2(-.05, -1), speed: 600);
          final bulletC = PlayerBullet(direction: Vector2(0, -1), speed: 600);
          final bulletR = PlayerBullet(direction: Vector2(.05, -1), speed: 600);
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
    } else if(other is! PlayerBullet) {
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

class PlayerBullet extends SpriteComponent with HasGameReference<AlienAttack>, CollisionCallbacks {
  Vector2 direction;
  double speed;

  PlayerBullet({required this.direction, this.speed = 500}) : super(size: Vector2(12, 24), anchor: Anchor.center, priority: 10);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = game.bulletSprite;

    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += direction.normalized() * speed * dt;

    if (position.y < 0) {
      removeFromParent();
    }
  }
}

class EnemyAlpha extends SpriteAnimationComponent with HasGameReference<AlienAttack>, CollisionCallbacks {
  final VoidCallback? onEnemyRemoved;
  final int speed;
  final bool straight;
  final int value;

  EnemyAlpha({this.onEnemyRemoved, this.speed = 100, this.straight = true, this.value = 25}) : super(size: Vector2.all(50), priority: 10);

  final random = Random();
  static const spriteHeight = 50.0;
  late double direction;

  double time = 0;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    direction = Random().nextBool() ? 1 : -1;

    animation = game.enemyAnimation;

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

    if (!straight) {
      time += dt;
      position.x += sin(time * 2) * 50 * dt * direction;
    }

    position.y += speed * dt;

    if (position.y > game.size.y + EnemyAlpha.spriteHeight) {
      removeFromParent();
      onEnemyRemoved?.call();
    }
  }

  @override
  Future<void> onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) async {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerBullet) {
      removeFromParent();
      other.removeFromParent();
      game.score += value;
      game.add(Explosion(position: position, size: Vector2.all(60)));
      SoundManager.playExplosionEnemy();
      onEnemyRemoved?.call();
    }
  }
}

class EnemyMissile1 extends SpriteAnimationComponent with HasGameReference<AlienAttack>, CollisionCallbacks {
  EnemyMissile1() : super(size: Vector2(20, 50), anchor: Anchor.center, priority: 10);

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

class Asteroid extends SpriteComponent with HasGameReference<AlienAttack>, CollisionCallbacks {
  final double speed;
  final Vector2 direction;

  Asteroid({
    required this.speed,
    required this.direction,
  }) : super(size: Vector2.all(64), anchor: Anchor.center, priority: 10);

  @override
  Future<void> onLoad() async {
    final int randomNumber = Random().nextInt(5);
    switch(randomNumber) {
      case 1: sprite = game.asteroid1Sprite; break;
      case 2: sprite = game.asteroid2Sprite; break;
      case 3: sprite = game.asteroid3Sprite; break;
      case 4: sprite = game.asteroid4Sprite; break;
      default: sprite = game.asteroid5Sprite; break;
    }

    add(CircleHitbox(
        collisionType: CollisionType.active)
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += direction.normalized() * speed * dt;
    angle += 0.5 * dt;

    if (position.y > game.size.y + 64 || position.x < -64 || position.x > game.size.x + 64) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if(other is PlayerBullet) {
      other.removeFromParent();
      game.add(SandBurst(position: intersectionPoints.first, size: Vector2.all(30)));
      SoundManager.playSandburst(volume: .6);
    }
  }
}

class Explosion extends SpriteAnimationComponent with HasGameReference<AlienAttack> {
  Explosion({super.position, super.size})
      : super(anchor: Anchor.center, priority: 10);

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

class SandBurst extends SpriteAnimationComponent with HasGameReference<AlienAttack> {
  SandBurst({super.position, super.size})
      : super(anchor: Anchor.center, priority: 10);

  @override
  Future<void> onLoad() async {

    animation = game.sandburstAnimation;

    animationTicker?.onComplete = removeFromParent;
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * 40;
  }
}

class PowerUp extends SpriteAnimationComponent with HasGameReference<AlienAttack>, CollisionCallbacks {
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

class BossIntro extends SpriteAnimationComponent
    with HasGameReference<AlienAttack> {
  final void Function(Vector2 position, double scale) onIntroComplete;

  BossIntro({required this.onIntroComplete})
      : super(size: Vector2.all(200), anchor: Anchor.center, priority: 15);

  @override
  Future<void> onLoad() async {
    position = Vector2(game.size.x / 2, game.size.y + 300); // Start unten
    scale = Vector2.all(3); // Etwas größer als Boss

    animation = await game.loadSpriteAnimation(
      'boss_shadow.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(600, 600),
        stepTime: 0.1,
      ),
    );

    // 1️⃣ Hochfahren
    final moveUp = MoveEffect.to(
      Vector2(game.size.x / 2, 100), // Zielposition
      EffectController(duration: 2.0, curve: Curves.easeOutQuad),
      onComplete: () {
        // 2️⃣ Schrumpfen auf Bossgröße
        final shrink = ScaleEffect.to(
          Vector2.all(1.0), // exakte Bossgröße
          EffectController(duration: 2.0, curve: Curves.easeInOut),
          onComplete: () {
            onIntroComplete(position.clone(), scale.x);
            removeFromParent();
          },
        );
        add(shrink);
      },
    );

    add(moveUp);
  }
}

class Boss extends SpriteAnimationComponent
    with HasGameReference<AlienAttack>, CollisionCallbacks {
  final VoidCallback onBossRemoved;

  Boss({required this.onBossRemoved}) : super(size: Vector2.all(200));

  double maxHealth = 100;
  double currentHealth = 100;

  late BossHealthBar healthBar;

  double speedY = 10;
  double horizontalSpeed = 0;      // aktuelle horizontale Geschwindigkeit
  double targetSpeed = 0;          // Zielgeschwindigkeit
  double driftTimer = 0;
  double driftDuration = 2;
  double time = 0;

  double fireTimer = 0;
  double fireInterval = 3;

  final random = Random();

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    animation = await game.loadSpriteAnimation(
      'boss.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        loop: true,
        stepTime: 20,
        textureSize: Vector2(600, 600),
      ),
    );

    position = Vector2(game.size.x / 2, 100);
    add(CircleHitbox());

    // HealthBar hinzufügen
    healthBar = BossHealthBar(pos: Vector2(size.x/2 + 50, -10)); // fix über dem Boss
    add(healthBar);

    // initial zufällige Zielgeschwindigkeit
    targetSpeed = (random.nextBool() ? 1 : -1) * (50 + random.nextDouble() * 100);
  }

  void takeDamage(double amount) {
    currentHealth -= amount;
    if (currentHealth < 0) currentHealth = 0;
    healthBar.updateHealth(currentHealth / maxHealth);

    if (currentHealth <= 0) {
      removeFromParent();
      game.score += 1000;
      game.add(Explosion(position: position, size: Vector2.all(500)));
      game.spawnCount = 0;
      SoundManager.playExplosionBoss(volume: 1);
      onBossRemoved();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    time += dt;
    driftTimer += dt;
    fireTimer += dt;

    // Zielrichtung regelmäßig ändern
    if (driftTimer >= driftDuration) {
      driftTimer = 0;
      driftDuration = 1 + random.nextDouble() * 3; // 1–4 s
      targetSpeed = (random.nextBool() ? 1 : -1) * (100 + random.nextDouble() * 300);
    }

    // Geschwindigkeit smooth an Zielgeschwindigkeit angleichen
    horizontalSpeed = lerpDouble(horizontalSpeed, targetSpeed, dt * 2)!;

    // Position updaten
    position.x += horizontalSpeed * dt;
    position.y += sin(time * 0.8) * 10 * dt + speedY * dt;

    // Smooth Neigung (max ±0.2 rad)
    double targetAngle = (horizontalSpeed / 400).clamp(-0.2, 0.2);
    angle = lerpDouble(angle, targetAngle, dt * 3)!;

    // Bildschirmbegrenzung prüfen
    if (position.x < size.x / 2 - 50) {
      position.x = size.x / 2 - 50;
      horizontalSpeed = horizontalSpeed.abs();
      targetSpeed = horizontalSpeed;
    } else if (position.x > game.size.x - size.x / 2 + 50) {
      position.x = game.size.x - size.x / 2 + 50;
      horizontalSpeed = -horizontalSpeed.abs();
      targetSpeed = horizontalSpeed;
    }

    if (fireTimer >= fireInterval) {
      fireTimer = 0;
      shootFireballs();
    }

    if(position.y > game.size.y) {
      game.over();
    }
  }

  void shootFireballs() {
    final center = position.clone();
    SoundManager.playFireballs(volume: 1);

    final count = 12;
    for (int i = 0; i < count; i++) {
      final angle = (2 * pi / count) * i;
      final dir = Vector2(cos(angle), sin(angle));
      final fireball = Fireball(direction: dir, speed: 250)
        ..position = center.clone();
      game.add(fireball);
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerBullet) {
      other.removeFromParent();
      game.add(Explosion(position: intersectionPoints.first, size: Vector2.all(80)));
      takeDamage(.25);
    }
  }
}

class Fireball extends SpriteComponent with HasGameReference<AlienAttack>, CollisionCallbacks {
  Vector2 direction;
  double speed;

  Fireball({required this.direction, this.speed = 150})
      : super(size: Vector2.all(40), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = game.fireballSprite;
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += direction.normalized() * speed * dt;

    angle = angle + dt * 10;

    // Entfernen, wenn außerhalb des Screens
    if (position.y > game.size.y + 50 ||
        position.y < -50 ||
        position.x < -50 ||
        position.x > game.size.x + 50) {
      removeFromParent();
    }
  }
}

class BossHealthBar extends PositionComponent {
  Vector2 pos;
  double progress = 1.0;

  BossHealthBar({required this.pos})
      : super(size: Vector2(100, 8), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    position = pos;
  }

  void updateHealth(double newProgress) {
    progress = newProgress.clamp(0.0, 1.0);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final bgRect = Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x, size.y);
    final fgRect = Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x * progress, size.y);

    canvas.drawRect(bgRect, Paint()..color = const Color(0xFF444444));
    canvas.drawRect(fgRect, Paint()..color = const Color(0xFFFF3333));
    canvas.drawRect(
      bgRect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }
}
