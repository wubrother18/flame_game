import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/rendering.dart';

import 'main.dart';

class SplashScreenPage extends Component with TapCallbacks, HasGameReference<MyGame>{
  @override
  Future<void> onLoad() async {
    addAll([
      TextBoxComponent(
        text: 'Start!',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xffffffff),
            fontSize: 48,
          ),
        ),
        align: Anchor.center,
        size: game.canvasSize,
      ),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) => game.router.pushNamed('home');
}