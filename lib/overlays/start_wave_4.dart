import 'package:flutter/material.dart';
import '../core/my_game.dart';

class StartWave4 extends StatelessWidget {
  final MyGame game;

  const StartWave4({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: !game.paused,
        child: Align(
          alignment: Alignment(0, -.4),
          child: Text(
            "Sie haben Mama gerufen! 😄",
            style: TextStyle(
              fontSize: 20,
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        )
    );
  }
}
