import 'package:flutter/material.dart';
import '../manager/achievement_manager.dart';
import 'achievement_button.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AchievementManager achievementManager;
  final VoidCallback onAchievementPressed;

  const CommonAppBar({
    Key? key,
    required this.title,
    required this.achievementManager,
    required this.onAchievementPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.emoji_events),
          onPressed: onAchievementPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 