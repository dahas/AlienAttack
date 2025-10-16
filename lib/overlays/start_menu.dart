import 'package:flutter/material.dart';
import '../core/my_game.dart';

class StartMenu extends StatelessWidget {
  final MyGame game;

  const StartMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: !game.paused,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: .6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "🛸",
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "ALIEN ATTACK",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Überlebe die feindlichen Angriffe und besiege den finalen Boss!",
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Steuerung:\n\n"
                        "WASD = Bewegen\nSpace = Schießen\n"
                        "P = Pause\nEsc = Abbrechen\n\n"
                        "Oder benutze die Maus/den Finger",
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent.shade400.withValues(alpha: 0.8),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      game.overlays.remove('StartMenu');
                      game.start();
                    },
                    child: const Text(
                      'Play',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Demo © 2025 martinwolf.info",
                    style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
