import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {

  static const String menuId = 'PauseMenu';

  final Game game;

  const PauseMenu({Key? key,required this.game}) : super(key: key);

  final TextStyle shadowStyle = const TextStyle(
      fontSize: 24,
      shadows: [Shadow(color: Colors.white,blurRadius: 10)]
  );


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          color: Colors.black54,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            spacing: 20,
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton(onPressed: _continue, child: const Text('繼續')),
              ElevatedButton(onPressed: _restart, child: const Text('重新')),
              ElevatedButton(onPressed: _exit, child: const Text('退出'))
            ],
          ),
        ),
      ),
    );
  }

  void _restart() {

  }

  void _continue() {
    game.resumeEngine();
    game.overlays.remove(menuId);
  }

  void _exit() {

  }
}