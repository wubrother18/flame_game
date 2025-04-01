import 'package:flutter/material.dart';
import 'package:flame_game/model/achievement_model.dart';
import 'package:flame_game/model/enums.dart';
import 'package:flame_game/manager/achievement_manager.dart';
import 'package:flame_game/manager/card_manager.dart';

class AchievementPage extends StatefulWidget {
  const AchievementPage({Key? key}) : super(key: key);

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  final AchievementManager _manager = AchievementManager.instance;
  final CardManager _cardManager = CardManager.instance;
  AchievementType _selectedType = AchievementType.collection;
  List<Achievement> _achievements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() => _isLoading = true);
    _achievements = await _manager.getAchievements();
    setState(() => _isLoading = false);
  }

  Future<void> _claimReward(Achievement achievement) async {
    if (!achievement.canClaim) return;

    final reward = await _manager.claimReward(achievement.type, achievement.id);
    if (reward.expReward > 0) {
      await CardManager.instance.addExperienceFromAchievement(reward.expReward,reward.itemRewards['gem'] ?? 0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('獲得 ${reward.expReward} 經驗值和 ${reward.itemRewards['gem'] ?? 0} 寶石'),
          backgroundColor: Colors.green,
        ),
      );
      await _loadAchievements();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('成就系統'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _achievements.length,
              itemBuilder: (context, index) {
                final achievement = _achievements[index];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      achievement.type == AchievementType.collection
                          ? Icons.collections
                          : achievement.type == AchievementType.level
                              ? Icons.trending_up
                              : achievement.type == AchievementType.event
                                  ? Icons.event
                                  : Icons.star,
                      color: achievement.canClaim ? Colors.orange : Colors.grey,
                    ),
                    title: Text(achievement.name),
                    subtitle: Text(
                      '${achievement.description}\n'
                      '進度: ${achievement.currentProgress}/${achievement.maxProgress}',
                    ),
                    trailing: achievement.canClaim
                        ? ElevatedButton(
                            onPressed: () => _claimReward(achievement),
                            child: const Text('領取'),
                          )
                        : achievement.claimed
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                  ),
                );
              },
            ),
    );
  }
} 