import 'package:flame/components.dart';
import '../core/my_game.dart';
import '../core/sprite_manager.dart';

class Sandburst extends SpriteAnimationComponent with HasGameReference<MyGame> {
  Sandburst({super.position, super.size})
      : super(anchor: Anchor.center, priority: 10);

  @override
  Future<void> onLoad() async {

    animation = SpriteManager.sandburstAnimation;

    animationTicker?.onComplete = removeFromParent;
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * 40;
  }
}