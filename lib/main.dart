import 'dart:async';
import 'package:alien_attack/overlays/game_over.dart';
import 'package:alien_attack/overlays/paused.dart';
import 'package:alien_attack/overlays/start_menu.dart';
import 'package:alien_attack/overlays/start_wave_1.dart';
import 'package:alien_attack/overlays/start_wave_2.dart';
import 'package:alien_attack/overlays/start_wave_3.dart';
import 'package:alien_attack/overlays/start_wave_4.dart';
import 'package:alien_attack/overlays/victory.dart';
import 'package:alien_attack/screens/loader.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'core/my_game.dart';
import 'core/sound_manager.dart';
import 'core/sprite_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const AlienAttack());
}

class AlienAttack extends StatefulWidget {
  const AlienAttack({super.key});

  @override
  State<AlienAttack> createState() => _AlienAttackState();
}

class _AlienAttackState extends State<AlienAttack> {
  bool _gameReady = false;
  late MyGame _game;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future<void> _initGame() async {
    await SpriteManager.loadAll();
    await SoundManager.init();

    _game = MyGame();

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _gameReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_gameReady) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Loader(),
      );
    }

    return GameWidget(
      game: _game,
      overlayBuilderMap: {
        'StartMenu': (BuildContext context, MyGame game) {
          return StartMenu(game: game);
        },
        'GameOver': (BuildContext context, MyGame game) {
          return GameOver(game: game);
        },
        'Paused': (BuildContext context, MyGame game) {
          return Paused(game: game);
        },
        'StartWave1': (BuildContext context, MyGame game) {
          return StartWave1(game: game);
        },
        'StartWave2': (BuildContext context, MyGame game) {
          return StartWave2(game: game);
        },
        'StartWave3': (BuildContext context, MyGame game) {
          return StartWave3(game: game);
        },
        'StartWave4': (BuildContext context, MyGame game) {
          return StartWave4(game: game);
        },
        'Victory': (BuildContext context, MyGame game) {
          return Victory(game: game);
        },
      },
    );
  }
}