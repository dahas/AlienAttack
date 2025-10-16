import 'package:flutter/material.dart';
import '../core/my_game.dart';

class Paused extends StatelessWidget {
  final MyGame game;

  const Paused({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
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
              "☕ Pausiert ☕",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
                "Drücke P um weiterzumachen ...",
                style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
                textAlign: TextAlign.center
            ),
          ],
        ),
      ),
    );
  }
}
