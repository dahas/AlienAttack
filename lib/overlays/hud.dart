import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'player_lifes.dart';

class Hud extends PositionComponent with HasGameReference<AlienAttack> {
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  late TextComponent _scoreTextComponent;

  @override
  Future<void> onLoad() async {
    _scoreTextComponent = TextComponent(
      text: '${game.starsCollected}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(255, 0, 0, 1.0),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 30, 20),
    );
    add(_scoreTextComponent);

    final starSprite = await game.loadSprite('star.png');
    add(
      SpriteComponent(
        sprite: starSprite,
        position: Vector2(game.size.x - 70, 20),
        size: Vector2.all(32),
        anchor: Anchor.center,
      ),
    );

    double positionX = -10;
    for (var i = 1; i <= 3; i++) {
      positionX += 25;
      await add(
        PlayerLifesComponent(
          lifesNumber: i,
          position: Vector2(positionX, 5),
          size: Vector2(20, 32),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = '${game.starsCollected}';
  }
}