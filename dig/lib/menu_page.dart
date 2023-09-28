import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'button.dart';
import 'landing_page.dart';

class MenuPage extends Component with HasGameReference<LandingPage> {
  late final RoundedButton _startNewGameButton;
  late final RoundedButton _loadGameButton;
  late final RoundedButton _achievementButton;

  MenuPage() {
    print('menu');
    addAll([
      _startNewGameButton = RoundedButton(
          text: "新遊戲",
          action: () {
            gotoGame();
          },
          color: const Color(0xffffffff),
          borderColor: const Color(0xffffffff)),
      _loadGameButton = RoundedButton(
          text: "繼續",
          action: () {},
          color: const Color(0xffffffff),
          borderColor: const Color(0xffffffff)),
      _achievementButton = RoundedButton(
          text: "成就",
          action: () {},
          color: const Color(0xffffffff),
          borderColor: const Color(0xffffffff)),
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _startNewGameButton.position = Vector2(size.x / 5, size.y * 7 / 8);
    _loadGameButton.position = Vector2(size.x * 2 / 5, size.y * 7 / 8);
    _achievementButton.position = Vector2(size.x * 3 / 5, size.y * 7 / 8);
  }

  void gotoGame() {
    game.router.pushNamed('game');
  }

  void loadGame() {}
}
