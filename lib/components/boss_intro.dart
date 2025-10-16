import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

import '../core/my_game.dart';

class BossIntro extends SpriteAnimationComponent
    with HasGameReference<MyGame> {
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
        textureSize: Vector2(300, 300),
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