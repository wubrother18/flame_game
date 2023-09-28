import 'package:dig/menu_page.dart';
import 'package:dig/pause_menu.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'landing_page.dart';

class GamePage extends FlameGame with HasGameReference<LandingPage>{



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