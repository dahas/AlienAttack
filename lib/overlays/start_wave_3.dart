import 'package:flutter/material.dart';
import '../core/my_game.dart';

class StartWave3 extends StatelessWidget {
  final MyGame game;

  const StartWave3({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: !game.paused,
        child: Align(
          alignment: Alignment(0, -.4),
          child: Text(
            "Du machst ihnen Angst! 💩",
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
