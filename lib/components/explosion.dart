import 'package:flame/components.dart';
import '../core/my_game.dart';

class Explosion extends SpriteAnimationComponent with HasGameReference<MyGame> {
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
        textureSize: Vector2(100, 100),
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