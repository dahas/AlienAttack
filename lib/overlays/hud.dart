import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../main.dart';

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
      text: '${game.score}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(255, 0, 0, 1.0),
        ),
      ),
      anchor: Anchor.centerRight,
      position: Vector2(game.size.x - 20, 20),
    );
    add(_scoreTextComponent);

    double positionX = -10;
    for (var i = 1; i <= 3; i++) {
      positionX += 25;
      await add(
        PlayerLifesComponent(
          lifesNumber: i,
          position: Vector2(positionX, 10),
          size: Vector2(20, 32),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = '${game.score}';
  }
}

enum LifesState {
  available,
  unavailable,
}

class PlayerLifesComponent extends SpriteGroupComponent<LifesState>
    with HasGameReference<AlienAttack> {
  final int lifesNumber;

  PlayerLifesComponent({
    required this.lifesNumber,
    required super.position,
    required super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final availableSprite = await game.loadSprite('life.png');
    final unavailableSprite = await game.loadSprite('life_lost.png');

    sprites = {
      LifesState.available: availableSprite,
      LifesState.unavailable: unavailableSprite,
    };

    current = LifesState.available;
  }

  @override
  void update(double dt) {
    if (game.lifes < lifesNumber) {
      current = LifesState.unavailable;
    } else {
      current = LifesState.available;
    }
    super.update(dt);
  }
}