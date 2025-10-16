import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import '../core/my_game.dart';
import '../core/sound_manager.dart';
import '../core/sprite_manager.dart';
import 'boss_explosion.dart';
import 'bullet.dart';
import 'explosion.dart';
import 'fireballs.dart';

class Boss extends SpriteAnimationComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  final VoidCallback onBossRemoved;

  late List<Sprite> fragmentSprites;

  Boss({required this.onBossRemoved}) : super(size: Vector2.all(200));

  double maxHealth = 100;
  double currentHealth = 100;

  late BossHealthBar healthBar;

  double speedY = 10;
  double horizontalSpeed = 0;
  double targetSpeed = 0;
  double driftTimer = 0;
  double driftDuration = 2;
  double time = 0;

  double fireTimer = 0;
  double fireInterval = 3;

  final random = Random();

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    fragmentSprites = [
      ?SpriteManager.bossFrg1Sprite,
      ?SpriteManager.bossFrg2Sprite,
      ?SpriteManager.bossFrg3Sprite,
      ?SpriteManager.bossFrg4Sprite,
      ?SpriteManager.bossFrg5Sprite,
      ?SpriteManager.bossFrg6Sprite,
      ?SpriteManager.bossFrg7Sprite,
    ];

    animation = await game.loadSpriteAnimation(
      'boss.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        loop: true,
        stepTime: 20,
        textureSize: Vector2(300, 300),
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
      game.add(BossExplosion(position: position, size: Vector2.all(400)));
      game.add(BossParticles(
        position: position.clone(),
        fragmentSprites: fragmentSprites,
      ));
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
      final fireball = Fireballs(direction: dir, speed: 250)
        ..position = center.clone();
      game.add(fireball);
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      other.removeFromParent();
      game.add(Explosion(position: intersectionPoints.first, size: Vector2.all(80)));
      takeDamage(.25);
    }
  }
}

class BossParticles extends ParticleSystemComponent {
  BossParticles({
    required Vector2 position,
    required List<Sprite> fragmentSprites,
  }) : super(
    position: position,
    particle: Particle.generate(
      count: 7,
      lifespan: 2,
      generator: (i) {
        final random = Random();
        final sprite = fragmentSprites[i % fragmentSprites.length];
        final size = 70.0 + random.nextDouble() * 20.0;
        final rotationSpeed = (random.nextDouble() - 0.5) * 3;

        return AcceleratedParticle(
          acceleration: Vector2.random() * 100, // Richtung
          speed: (Vector2.random() - Vector2.random()) * 600,
          position: Vector2.zero(),
          child: RotatingParticle(
            from: 0,
            to: 2 * pi * rotationSpeed,
            child: SpriteParticle(
              sprite: sprite,
              size: Vector2.all(size),
              lifespan: 2,
            ),
          ),
        );
      },
    ),
  );
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