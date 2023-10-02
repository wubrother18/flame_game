import 'package:dig/menu_page.dart';
import 'package:dig/pause_menu.dart';
import 'package:dig/platform_block.dart';
import 'package:dig/player.dart';
import 'package:dig/segment_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';

import 'block.dart';
import 'landing_page.dart';

class GamePage extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents ,HasGameReference<LandingPage>{
  late EmberPlayer _ember;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;
  late final JoystickComponent joystick;

  int starsCollected = 0;
  int health = 3;
  double cloudSpeed = 0.0;
  double objectSpeed = 0.0;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);
    camera.viewfinder.anchor = Anchor.topLeft;

    initializeGame(loadHud: true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero()) {
      Vector2 ds = joystick.relativeDelta * _ember.moveSpeed * dt;
      _ember.move(ds);
    }
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case GroundBlock:
          world.add(
            GroundBlock(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
        case PlatformBlock:
          world.add(
            PlatformBlock(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;

      }
    }
  }

  void initializeGame({required bool loadHud}) {

    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    _ember = EmberPlayer(
      position: Vector2(128, canvasSize.y - 128),
    );
    world.add(_ember);
    if (loadHud) {
      // camera.viewport.add(Hud());
    }

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 25, paint: knobPaint),
      background: CircleComponent(radius: 60, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    world.add(joystick);
  }

  void toggleGameState(){
    if(paused){
      resumeEngine();
      overlays.remove(PauseMenu.menuId);
    }else{
      pauseEngine();
      overlays.add(PauseMenu.menuId);
    }
  }
}