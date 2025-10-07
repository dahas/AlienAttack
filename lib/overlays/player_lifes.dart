import 'package:flame/components.dart';
import '../main.dart';

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