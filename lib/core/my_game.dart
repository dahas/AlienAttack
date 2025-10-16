import 'dart:math';
import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flame/parallax.dart';
import '../components/player.dart';
import '../components/asteroid.dart';
import '../components/boss.dart';
import '../components/boss_intro.dart';
import '../components/bullet.dart';
import '../components/enemy.dart';
import '../components/fireballs.dart';
import '../components/missile.dart';
import '../components/powerup.dart';
import '../core/sound_manager.dart';
import '../core/sprite_manager.dart';
import '../overlays/hud.dart';

class MyGame extends FlameGame with KeyboardEvents, PanDetector, HasCollisionDetection {
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

  @override
  Future<void> onLoad() async {
    await SoundManager.init();
    await SpriteManager.loadAll();

    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData(SpriteManager.parallax0!),
        ParallaxImageData(SpriteManager.parallax1!),
        ParallaxImageData(SpriteManager.parallax2!),
      ],
      priority: 0,
      baseVelocity: Vector2(0, -4),
      repeat: ImageRepeat.repeatY,
      fill: LayerFill.width,
      velocityMultiplierDelta: Vector2(0, 2),
    );
    add(parallax);

    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewport.add(Hud());

    player = Player();

    overlays.remove('Loading');
    overlays.add("StartMenu");
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
            return Enemy(onEnemyRemoved: onSpawnFinished, speed: 200, value: 25);
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
            return Enemy(onEnemyRemoved: onSpawnFinished, speed: 250, straight: false, value: 50);
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
            return Enemy(onEnemyRemoved: onSpawnFinished, speed: 300, straight: false, value: 75);
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
            return Enemy(speed: 300, straight: false);
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
    component is Enemy ||
        component is Bullet ||
        component is SpawnComponent ||
        component is Missile ||
        component is Asteroid ||
        component is PowerUp ||
        component is Boss ||
        component is Fireballs
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
      SoundManager.pauseBackgroundMusic();
      overlays.add("Paused");
    } else {
      SoundManager.resumeBackgroundMusic();
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
    clear();
    SoundManager.dispose();
    SpriteManager.dispose();
    super.onDispose();
  }
}