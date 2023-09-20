import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart' as g;
import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame_game/splash_page.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

Future<void> main() async {
  ///連結硬體
  WidgetsFlutterBinding.ensureInitialized();
  ///設為全螢幕
  Flame.device.fullScreen();
  ///設為垂直
  Flame.device.setPortrait();
  runApp(
    g.GameWidget(
      game: MyGame(),
      overlayBuilderMap: {
        'PauseMenu': (context, game) {
          return Container(
            color: const Color(0xFF000000),
            child: const Text('pause!!!'),
          );
        },
      },
    ),
  );
}

class MyGame extends g.FlameGame {
  late final g.RouterComponent router;

  @override
  Future<void> onLoad() async {
    add(
      router = g.RouterComponent(
        routes: {
          'splash': g.Route(SplashScreenPage.new),
          'home': g.Route(HomePage.new),
        },
        initialRoute: 'splash',
      ),
    );
  }
}

class AnimatedComponent extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef {

  final Vector2 velocity;

  AnimatedComponent(
      this.velocity,
      Vector2 position,
      Vector2 size, {
        double angle = -pi / 4,
      }) : super(
    position: position,
    size: size,
    angle: angle,
    anchor: Anchor.center,
  );
  Offset circleCenter = const Offset(0, 0);
  final Paint paint = Paint()..color = Colors.yellow;

  @override
  Future<void> onLoad() async {

    final hitboxPaint = BasicPalette.transparent.paint()
    ..color = Colors.yellow
      ..style = PaintingStyle.stroke;
    add(
      CircleHitbox()..paint = hitboxPaint .. radius = 30
    );
  }

  @override
  void render(Canvas canvas){
    super.render(canvas);
    canvas.drawCircle(circleCenter, 20, paint);
  }


  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  final Paint hitboxPaint = BasicPalette.green.paint()
    ..style = PaintingStyle.stroke;
  final Paint dotPaint = BasicPalette.red.paint()..style = PaintingStyle.stroke;

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);
    velocity.negate();
    flipVertically();
  }

}

