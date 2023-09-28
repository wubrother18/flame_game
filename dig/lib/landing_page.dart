import 'package:dig/game_page.dart';
import 'package:dig/menu_page.dart';
import 'package:flame/game.dart';

class LandingPage extends FlameGame {
  late final RouterComponent router;

  @override
  Future<void> onLoad() async {
    add(
      router = RouterComponent(
        routes: {
          'landing': Route(LandingPage.new),
          'menu': Route(MenuPage.new),
          'game': Route(GamePage.new),
        }, initialRoute: 'menu',
      ),
    );
  }
}