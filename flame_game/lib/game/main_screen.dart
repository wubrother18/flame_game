import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_game/game/touch_target.dart';
import 'package:flame_game/model/user_data.dart';
import 'package:flame_game/static.dart';

import '../button.dart';
import '../home_page.dart';
import '../splash_page.dart';

class MyGame extends FlameGame {
  late final RouterComponent router;
  late final RoundedButton _button1;
  late final RoundedButton _button2;
  late final RoundedButton _button3;
  late final RoundedButton _button4;
  late final RoundedButton _button5;

  MyGame(){
    addAll([
      TapTarget(),
    //   _button1 = RoundedButton(
    //       text: "強化",
    //       action: () {},
    //       color: Color(0xffffffff),
    //       borderColor: Color(0xffffffff)),
    //   _button2 = RoundedButton(
    //       text: "故事",
    //       action: () {},
    //       color: Color(0xffffffff),
    //       borderColor: Color(0xffffffff)),
    //   _button3 = RoundedButton(
    //       text: "主頁",
    //       action: () {},
    //       color: Color(0xffffffff),
    //       borderColor: Color(0xffffffff)),
    //   _button4 = RoundedButton(
    //       text: "資源",
    //       action: () {},
    //       color: Color(0xffffffff),
    //       borderColor: Color(0xffffffff)),
      _button5 = RoundedButton(
          text: "固拉多本多",
          action: () {

          },
          color: Color(0xffffffff),
          borderColor: Color(0xffffffff)),
    ]);
  }
  @override
  Future<void> onLoad() async {
    // add(
    //   router = RouterComponent(
    //     routes: {
    //       'splash': Route(SplashScreenPage.new),
    //       'home': Route(HomePage.new),
    //     },
    //     initialRoute: 'splash',
    //   ),
    // );

  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // _button1.position = Vector2(size.x / 5, size.y *7/ 8);
    // _button2.position = Vector2(size.x *2/ 5, size.y *7/ 8);
    // _button3.position = Vector2(size.x *3/ 5, size.y *7/ 8);
    // _button4.position = Vector2(size.x *4/ 5, size.y *7/ 8);
    _button5.position = Vector2(size.x /2, size.y *4/ 8);
  }
}

class AnimatedComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {
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
  final Paint paint = Paint()..color = const Color.fromARGB(255, 255, 255, 0);

  @override
  Future<void> onLoad() async {
    final hitboxPaint = BasicPalette.transparent.paint()
      ..color = const Color.fromARGB(255, 255, 255, 0)
      ..style = PaintingStyle.stroke;
    add(CircleHitbox()
      ..paint = hitboxPaint
      ..radius = 30);
  }

  @override
  void render(Canvas canvas) {
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
