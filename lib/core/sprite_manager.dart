import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class SpriteManager {
  static late String? parallax0;
  static late String? parallax1;
  static late String? parallax2;

  static late Sprite? bulletSprite;
  static late Sprite? asteroid1Sprite;
  static late Sprite? asteroid1Frg1Sprite;
  static late Sprite? asteroid1Frg2Sprite;
  static late Sprite? asteroid1Frg3Sprite;
  static late Sprite? asteroid1Frg4Sprite;
  static late Sprite? asteroid1Frg5Sprite;
  static late Sprite? asteroid2Sprite;
  static late Sprite? asteroid2Frg1Sprite;
  static late Sprite? asteroid2Frg2Sprite;
  static late Sprite? asteroid2Frg3Sprite;
  static late Sprite? asteroid2Frg4Sprite;
  static late Sprite? asteroid2Frg5Sprite;
  static late Sprite? asteroid3Sprite;
  static late Sprite? asteroid3Frg1Sprite;
  static late Sprite? asteroid3Frg2Sprite;
  static late Sprite? asteroid3Frg3Sprite;
  static late Sprite? asteroid3Frg4Sprite;
  static late Sprite? asteroid3Frg5Sprite;
  static late Sprite? asteroid4Sprite;
  static late Sprite? asteroid4Frg1Sprite;
  static late Sprite? asteroid4Frg2Sprite;
  static late Sprite? asteroid4Frg3Sprite;
  static late Sprite? asteroid4Frg4Sprite;
  static late Sprite? asteroid4Frg5Sprite;
  static late Sprite? asteroid5Sprite;
  static late Sprite? asteroid5Frg1Sprite;
  static late Sprite? asteroid5Frg2Sprite;
  static late Sprite? asteroid5Frg3Sprite;
  static late Sprite? asteroid5Frg4Sprite;
  static late Sprite? asteroid5Frg5Sprite;
  static late Sprite? fireballSprite;
  static late Sprite? bossFrg1Sprite;
  static late Sprite? bossFrg2Sprite;
  static late Sprite? bossFrg3Sprite;
  static late Sprite? bossFrg4Sprite;
  static late Sprite? bossFrg5Sprite;
  static late Sprite? bossFrg6Sprite;
  static late Sprite? bossFrg7Sprite;

  static late SpriteAnimation? enemyAnimation;
  static late SpriteAnimation? sandburstAnimation;
  static late SpriteAnimation? missile1Animation;

  static Future<void> loadAll() async {
    await Flame.images.loadAll([
      'stars_0.png',
      'stars_1.png',
      'stars_2.png',
      'player.png',
      'bullet.png',
      'enemy.png',
      'life_lost.png',
      'life.png',
      'explosion.png',
      'sandburst.png',
      'missile1.png',
      'asteroid1.png',
      'asteroid1_fragment1.png',
      'asteroid1_fragment2.png',
      'asteroid1_fragment3.png',
      'asteroid1_fragment4.png',
      'asteroid1_fragment5.png',
      'asteroid2.png',
      'asteroid2_fragment1.png',
      'asteroid2_fragment2.png',
      'asteroid2_fragment3.png',
      'asteroid2_fragment4.png',
      'asteroid2_fragment5.png',
      'asteroid3.png',
      'asteroid3_fragment1.png',
      'asteroid3_fragment2.png',
      'asteroid3_fragment3.png',
      'asteroid3_fragment4.png',
      'asteroid3_fragment5.png',
      'asteroid4.png',
      'asteroid4_fragment1.png',
      'asteroid4_fragment2.png',
      'asteroid4_fragment3.png',
      'asteroid4_fragment4.png',
      'asteroid4_fragment5.png',
      'asteroid5.png',
      'asteroid5_fragment1.png',
      'asteroid5_fragment2.png',
      'asteroid5_fragment3.png',
      'asteroid5_fragment4.png',
      'asteroid5_fragment5.png',
      'powerup1.png',
      'powerup2.png',
      'powerup3.png',
      'boss_shadow.png',
      'boss.png',
      'boss_fragment1.png',
      'boss_fragment2.png',
      'boss_fragment3.png',
      'boss_fragment4.png',
      'boss_fragment5.png',
      'boss_fragment6.png',
      'boss_fragment7.png',
      'fireball.png',
    ]);

    parallax0 = "stars_0.png";
    parallax1 = "stars_1.png";
    parallax2 = "stars_2.png";
    bulletSprite = Sprite(Flame.images.fromCache("bullet.png"));
    asteroid1Sprite = Sprite(Flame.images.fromCache("asteroid1.png"));
    asteroid1Frg1Sprite = Sprite(Flame.images.fromCache("asteroid1_fragment1.png"));
    asteroid1Frg2Sprite = Sprite(Flame.images.fromCache("asteroid1_fragment2.png"));
    asteroid1Frg3Sprite = Sprite(Flame.images.fromCache("asteroid1_fragment3.png"));
    asteroid1Frg4Sprite = Sprite(Flame.images.fromCache("asteroid1_fragment4.png"));
    asteroid1Frg5Sprite = Sprite(Flame.images.fromCache("asteroid1_fragment5.png"));
    asteroid2Sprite = Sprite(Flame.images.fromCache("asteroid2.png"));
    asteroid2Frg1Sprite = Sprite(Flame.images.fromCache("asteroid2_fragment1.png"));
    asteroid2Frg2Sprite = Sprite(Flame.images.fromCache("asteroid2_fragment2.png"));
    asteroid2Frg3Sprite = Sprite(Flame.images.fromCache("asteroid2_fragment3.png"));
    asteroid2Frg4Sprite = Sprite(Flame.images.fromCache("asteroid2_fragment4.png"));
    asteroid2Frg5Sprite = Sprite(Flame.images.fromCache("asteroid2_fragment5.png"));
    asteroid3Sprite = Sprite(Flame.images.fromCache("asteroid3.png"));
    asteroid3Frg1Sprite = Sprite(Flame.images.fromCache("asteroid3_fragment1.png"));
    asteroid3Frg2Sprite = Sprite(Flame.images.fromCache("asteroid3_fragment2.png"));
    asteroid3Frg3Sprite = Sprite(Flame.images.fromCache("asteroid3_fragment3.png"));
    asteroid3Frg4Sprite = Sprite(Flame.images.fromCache("asteroid3_fragment4.png"));
    asteroid3Frg5Sprite = Sprite(Flame.images.fromCache("asteroid3_fragment5.png"));
    asteroid4Sprite = Sprite(Flame.images.fromCache("asteroid4.png"));
    asteroid4Frg1Sprite = Sprite(Flame.images.fromCache("asteroid4_fragment1.png"));
    asteroid4Frg2Sprite = Sprite(Flame.images.fromCache("asteroid4_fragment2.png"));
    asteroid4Frg3Sprite = Sprite(Flame.images.fromCache("asteroid4_fragment3.png"));
    asteroid4Frg4Sprite = Sprite(Flame.images.fromCache("asteroid4_fragment4.png"));
    asteroid4Frg5Sprite = Sprite(Flame.images.fromCache("asteroid4_fragment5.png"));
    asteroid5Sprite = Sprite(Flame.images.fromCache("asteroid5.png"));
    asteroid5Frg1Sprite = Sprite(Flame.images.fromCache("asteroid5_fragment1.png"));
    asteroid5Frg2Sprite = Sprite(Flame.images.fromCache("asteroid5_fragment2.png"));
    asteroid5Frg3Sprite = Sprite(Flame.images.fromCache("asteroid5_fragment3.png"));
    asteroid5Frg4Sprite = Sprite(Flame.images.fromCache("asteroid5_fragment4.png"));
    asteroid5Frg5Sprite = Sprite(Flame.images.fromCache("asteroid5_fragment5.png"));
    fireballSprite = Sprite(Flame.images.fromCache("fireball.png"));
    bossFrg1Sprite = Sprite(Flame.images.fromCache("boss_fragment1.png"));
    bossFrg2Sprite = Sprite(Flame.images.fromCache("boss_fragment2.png"));
    bossFrg3Sprite = Sprite(Flame.images.fromCache("boss_fragment3.png"));
    bossFrg4Sprite = Sprite(Flame.images.fromCache("boss_fragment4.png"));
    bossFrg5Sprite = Sprite(Flame.images.fromCache("boss_fragment5.png"));
    bossFrg6Sprite = Sprite(Flame.images.fromCache("boss_fragment6.png"));
    bossFrg7Sprite = Sprite(Flame.images.fromCache("boss_fragment7.png"));

    enemyAnimation = await SpriteAnimation.load(
      'enemy.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        loop: true,
        stepTime: .3,
        textureSize: Vector2(50, 54),
      ),
    );

    sandburstAnimation = await SpriteAnimation.load(
      'sandburst.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        loop: false,
        stepTime: .1,
        textureSize: Vector2(50, 50),
      ),
    );

    missile1Animation = await SpriteAnimation.load(
      'missile1.png',
      SpriteAnimationData.sequenced(
        amount: 5,
        loop: true,
        stepTime: .1,
        textureSize: Vector2(20, 75),
      ),
    );
  }

  static void dispose() {
    enemyAnimation = null;
    sandburstAnimation = null;
    missile1Animation = null;

    parallax0 = null;
    parallax1 = null;
    parallax2 = null;
    bulletSprite = null;
    asteroid1Sprite = null;
    asteroid1Frg1Sprite = null;
    asteroid1Frg2Sprite = null;
    asteroid1Frg3Sprite = null;
    asteroid1Frg4Sprite = null;
    asteroid1Frg5Sprite = null;
    asteroid2Sprite = null;
    asteroid2Frg1Sprite = null;
    asteroid2Frg2Sprite = null;
    asteroid2Frg3Sprite = null;
    asteroid2Frg4Sprite = null;
    asteroid2Frg5Sprite = null;
    asteroid3Sprite = null;
    asteroid3Frg1Sprite = null;
    asteroid3Frg2Sprite = null;
    asteroid3Frg3Sprite = null;
    asteroid3Frg4Sprite = null;
    asteroid3Frg5Sprite = null;
    asteroid4Sprite = null;
    asteroid4Frg1Sprite = null;
    asteroid4Frg2Sprite = null;
    asteroid4Frg3Sprite = null;
    asteroid4Frg4Sprite = null;
    asteroid4Frg5Sprite = null;
    asteroid5Sprite = null;
    asteroid5Frg1Sprite = null;
    asteroid5Frg2Sprite = null;
    asteroid5Frg3Sprite = null;
    asteroid5Frg4Sprite = null;
    asteroid5Frg5Sprite = null;
    fireballSprite = null;
  }
}