import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  static AudioPool? _explosionEnemyPool;
  static AudioPool? _sandburstPool;
  static AudioPool? _fireballsPool;

  static AudioPlayer? _bgmPlayer;

  static String? _backgroundMusic;

  static String? _powerUp1;
  static String? _powerUp2;
  static String? _powerUp3;

  static String? _explosionPlayer;
  static String? _explosionBoss;
  static String? _burstAsteroid;

  static Future<void> init() async {
    await FlameAudio.audioCache.loadAll([
      'background.wav',
      'shot.wav',
      'powerup1.wav',
      'powerup2.wav',
      'powerup3.wav',
      'explosionBoss.wav',
      'explosionEnemy.wav',
      'explosionPlayer.wav',
      'sandburst.wav',
      'fireballs.wav',
      'burst.wav',
    ]);

    _explosionEnemyPool ??= await FlameAudio.createPool('explosionEnemy.wav', maxPlayers: 4);
    _sandburstPool ??= await FlameAudio.createPool('sandburst.wav', maxPlayers: 4);
    _fireballsPool ??= await FlameAudio.createPool('fireballs.wav', maxPlayers: 3);

    _backgroundMusic = "background.wav";

    _powerUp1 = "powerup1.wav";
    _powerUp2 = "powerup2.wav";
    _powerUp3 = "powerup3.wav";

    _explosionPlayer = "explosionPlayer.wav";
    _explosionBoss = "explosionBoss.wav";
    _burstAsteroid = "burst.wav";
  }

  static void playBackgroundMusic({double volume = 1}) async {
    _bgmPlayer ??= await FlameAudio.loop(_backgroundMusic!, volume: volume);
  }

  static void pauseBackgroundMusic() {
    _bgmPlayer?.pause();
  }

  static void resumeBackgroundMusic() {
    _bgmPlayer?.resume();
  }

  static void playSandburst({double volume = 1}) {
    _sandburstPool?.start(volume: volume);
  }

  static void playExplosionEnemy({double volume = 1}) {
    _explosionEnemyPool?.start(volume: volume);
  }

  static void playFireballs({double volume = 1}) {
    _fireballsPool?.start(volume: volume);
  }

  static void playPowerUp1({double volume = 1}) {
    FlameAudio.play(_powerUp1!, volume: volume);
  }

  static void playPowerUp2({double volume = 1}) {
    FlameAudio.play(_powerUp2!, volume: volume);
  }

  static void playPowerUp3({double volume = 1}) {
    FlameAudio.play(_powerUp3!, volume: volume);
  }

  static void playExplosionPlayer({double volume = 1}) {
    FlameAudio.play(_explosionPlayer!, volume: volume);
  }

  static void playExplosionBoss({double volume = 1}) {
    FlameAudio.play(_explosionBoss!, volume: volume);
  }

  static void playBurstAsteroid({double volume = 1}) {
    FlameAudio.play(_burstAsteroid!, volume: volume);
  }

  static void dispose() {
    _sandburstPool?.dispose();
    _explosionEnemyPool?.dispose();
    _fireballsPool?.dispose();
    _bgmPlayer?.dispose();
    _sandburstPool = null;
    _explosionEnemyPool = null;
    _fireballsPool = null;
    _bgmPlayer = null;

    _powerUp1 = null;
    _powerUp2 = null;
    _powerUp3 = null;
    _explosionPlayer = null;
    _explosionBoss = null;
    _burstAsteroid = null;
  }
}
