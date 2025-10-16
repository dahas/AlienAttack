import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(12, 21, 32, 255),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/loader_icon.png', width: 200),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: Colors.cyanAccent),
            const SizedBox(height: 12),
            const Text(
              'Momentchen ...',
              style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}