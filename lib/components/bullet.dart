import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../core/my_game.dart';
import '../core/sprite_manager.dart';

class Bullet extends SpriteComponent with HasGameReference<MyGame>, CollisionCallbacks {
  Vector2 direction;
  double speed;

  Bullet({required this.direction, this.speed = 500}) : super(size: Vector2(12, 24), anchor: Anchor.center, priority: 10);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = SpriteManager.bulletSprite;

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