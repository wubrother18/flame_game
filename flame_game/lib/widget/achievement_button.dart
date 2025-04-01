import 'package:flutter/material.dart';
import 'package:flame_game/manager/achievement_manager.dart';

class AchievementButton extends StatelessWidget {
  final AchievementManager achievementManager;

  const AchievementButton({
    Key? key,
    required this.achievementManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.emoji_events),
      onPressed: () {
        Navigator.pushNamed(context, '/achievements');
      },
    );
  }
} 