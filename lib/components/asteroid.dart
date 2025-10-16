import 'dart:math';
import 'package:alien_attack/components/sandburst.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import '../core/my_game.dart';
import '../core/sound_manager.dart';
import '../core/sprite_manager.dart';
import 'bullet.dart';

class Asteroid extends SpriteComponent with HasGameReference<MyGame>, CollisionCallbacks {
  final double speed;
  final Vector2 direction;

  int hitCount = 0;

  late List<Sprite> fragmentSprites;

  Asteroid({
    required this.speed,
    required this.direction,
  }) : super(size: Vector2.all(64), anchor: Anchor.center, priority: 10);

  @override
  Future<void> onLoad() async {
    final int randomNumber = Random().nextInt(5);
    switch(randomNumber) {
      case 1:
        sprite = SpriteManager.asteroid1Sprite;
        fragmentSprites = [
          ?SpriteManager.asteroid1Frg1Sprite,
          ?SpriteManager.asteroid1Frg2Sprite,
          ?SpriteManager.asteroid1Frg3Sprite,
          ?SpriteManager.asteroid1Frg4Sprite,
          ?SpriteManager.asteroid1Frg5Sprite,
        ];
        break;
      case 2:
        sprite = SpriteManager.asteroid2Sprite;
        fragmentSprites = [
          ?SpriteManager.asteroid2Frg1Sprite,
          ?SpriteManager.asteroid2Frg2Sprite,
          ?SpriteManager.asteroid2Frg3Sprite,
          ?SpriteManager.asteroid2Frg4Sprite,
          ?SpriteManager.asteroid2Frg5Sprite,
        ];
        break;
      case 3:
        sprite = SpriteManager.asteroid3Sprite;
        fragmentSprites = [
          ?SpriteManager.asteroid3Frg1Sprite,
          ?SpriteManager.asteroid3Frg2Sprite,
          ?SpriteManager.asteroid3Frg3Sprite,
          ?SpriteManager.asteroid3Frg4Sprite,
          ?SpriteManager.asteroid3Frg5Sprite,
        ];
        break;
      case 4:
        sprite = SpriteManager.asteroid4Sprite;
        fragmentSprites = [
          ?SpriteManager.asteroid4Frg1Sprite,
          ?SpriteManager.asteroid4Frg2Sprite,
          ?SpriteManager.asteroid4Frg3Sprite,
          ?SpriteManager.asteroid4Frg4Sprite,
          ?SpriteManager.asteroid4Frg5Sprite,
        ];
      default:
        sprite = SpriteManager.asteroid5Sprite;
        fragmentSprites = [
          ?SpriteManager.asteroid5Frg1Sprite,
          ?SpriteManager.asteroid5Frg2Sprite,
          ?SpriteManager.asteroid5Frg3Sprite,
          ?SpriteManager.asteroid5Frg4Sprite,
          ?SpriteManager.asteroid5Frg5Sprite,
        ];
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

    if(other is Bullet) {
      hitCount++;
      other.removeFromParent();
      game.add(Sandburst(position: intersectionPoints.first, size: Vector2.all(30)));
      SoundManager.playSandburst(volume: .6);
      if (hitCount >= 20) {
        removeFromParent();
        game.add(AsteroidParticles(
          position: position.clone(),
          fragmentSprites: fragmentSprites,
        ),
        );
        SoundManager.playBurstAsteroid();
      }
    }
  }
}

class AsteroidParticles extends ParticleSystemComponent {
  AsteroidParticles({
    required Vector2 position,
    required List<Sprite> fragmentSprites,
  }) : super(
    position: position,
    particle: Particle.generate(
      count: 5,
      generator: (i) {
        final random = Random();
        final sprite = fragmentSprites[i % fragmentSprites.length];
        final size = 30.0 + random.nextDouble() * 20.0;
        final rotationSpeed = (random.nextDouble() - 0.5) * 3;

        return AcceleratedParticle(
          acceleration: Vector2(0, 50),
          speed: (Vector2.random() - Vector2.random()) * 400,
          position: Vector2.zero(),
          child: RotatingParticle(
            from: 0,
            to: 2 * pi * rotationSpeed,
            child: SpriteParticle(
              sprite: sprite,
              size: Vector2.all(size),
              lifespan: 1.5,
            ),
          ),
        );
      },
    ),
  );
}