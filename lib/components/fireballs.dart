import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../core/my_game.dart';
import '../core/sprite_manager.dart';

class Fireballs extends SpriteComponent with HasGameReference<MyGame>, CollisionCallbacks {
  Vector2 direction;
  double speed;

  Fireballs({required this.direction, this.speed = 150})
      : super(size: Vector2.all(40), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = SpriteManager.fireballSprite;
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