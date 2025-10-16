import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../core/my_game.dart';
import '../core/sprite_manager.dart';

class Missile extends SpriteAnimationComponent with HasGameReference<MyGame>, CollisionCallbacks {
  Missile() : super(size: Vector2(20, 50), anchor: Anchor.center, priority: 10);

  final speed = 400;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    animation = SpriteManager.missile1Animation;

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