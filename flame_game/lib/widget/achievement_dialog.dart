import 'package:flutter/material.dart';
import 'package:flame_game/manager/achievement_manager.dart';
import 'package:flame_game/model/achievement_model.dart';
import 'package:flame_game/model/enums.dart';

class AchievementDialog extends StatefulWidget {
  final AchievementManager achievementManager;

  const AchievementDialog({
    Key? key,
    required this.achievementManager,
  }) : super(key: key);

  @override
  State<AchievementDialog> createState() => _AchievementDialogState();
}

class _AchievementDialogState extends State<AchievementDialog> {
  AchievementType _selectedType = AchievementType.collection;
  List<Achievement>? _completedAchievements;
  List<Achievement>? _uncompletedAchievements;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final completed = await widget.achievementManager.getCompletedAchievements();
    final uncompleted = await widget.achievementManager.getUncompletedAchievements();
    if (mounted) {
      setState(() {
        _completedAchievements = completed;
        _uncompletedAchievements = uncompleted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 600,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '成就系統',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTypeSelector(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildAchievementList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: AchievementType.values.map((type) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(_getTypeLabel(type)),
              selected: _selectedType == type,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedType = type;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAchievementList() {
    if (_completedAchievements == null || _uncompletedAchievements == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final achievements = [
      ..._uncompletedAchievements!.where((a) => a.type == _selectedType),
      ..._completedAchievements!.where((a) => a.type == _selectedType),
    ];

    if (achievements.isEmpty) {
      return const Center(child: Text('暫無成就'));
    }

    return ListView.builder(
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _buildAchievementTile(achievement);
      },
    );
  }

  Widget _buildAchievementTile(Achievement achievement) {
    final isCompleted = achievement.isCompleted;
    final canClaim = achievement.canClaim;

    return Card(
      child: ListTile(
        leading: Icon(
          Icons.emoji_events,
          color: _getAchievementColor(achievement.tier),
        ),
        title: Text(achievement.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(achievement.description),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: achievement.progressPercentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getAchievementColor(achievement.tier),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '進度: ${achievement.currentProgress}/${achievement.maxProgress}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: canClaim
            ? ElevatedButton(
                onPressed: () => _claimReward(achievement),
                child: const Text('領取'),
              )
            : isCompleted
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
      ),
    );
  }

  Future<void> _claimReward(Achievement achievement) async {
    final reward = await widget.achievementManager.claimReward(
      achievement.type,
      int.parse(achievement.id),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('獲得獎勵：${reward.expReward} 經驗值'),
        ),
      );
      _loadAchievements();
    }
  }

  String _getTypeLabel(AchievementType type) {
    return switch (type) {
      AchievementType.collection => '收集',
      AchievementType.level => '等級',
      AchievementType.event => '事件',
      AchievementType.special => '特殊',
    };
  }

  Color _getAchievementColor(int tier) {
    return switch (tier) {
      1 => Colors.brown,
      2 => Colors.grey,
      3 => Colors.amber,
      _ => Colors.blue,
    };
  }
} 