import 'package:flutter/material.dart';
import 'package:flame_game/manager/achievement_manager.dart';
import 'package:flame_game/manager/card_manager.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/enums.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final AchievementManager _achievementManager = AchievementManager.instance;
  final CardManager _cardManager = CardManager.instance;
  String _testResult = '';

  @override
  void initState() {
    super.initState();
    _initializeManagers();
  }

  Future<void> _initializeManagers() async {
    await _cardManager.init();
    await _achievementManager.init();
    setState(() {});
  }

  Future<void> _testCardCollection() async {
    final card = CardModel(
      id: 'test_card_1',
      name: '測試卡片',
      description: '這是一張測試卡片',
      image: 'assets/images/cards/test_card.png',
      rank: CardRank.R,
      maxLevel: 10,
      connectionNumber: 3,
      hpBonus: 80,
      mpBonus: 70,
      pointsBonus: 60,
      creativityBonus: 80,
      popularityBonus: 60,
      supportEvents: [],
      storyEvents: [],
      uniqueEvents: [],
      childList: [],
      baseHp: 10,
      baseMp: 10,
      basePoint: 10,
      baseCreate: 10,
      basePopular: 10,
    );

    await _cardManager.collectCard(card);
    setState(() {
      _testResult = '已收集卡片：${_cardManager.collectedCards.length}張\n'
          '當前經驗值：${_cardManager.experience}';
    });
  }

  Future<void> _testAchievement() async {
    await _achievementManager.updateProgress(
      AchievementType.collection,
      1,
      1,
    );

    final reward = await _achievementManager.claimReward(
      AchievementType.collection,
      1,
    );
    setState(() {
      _testResult = '已領取成就獎勵：\n'
          '經驗值：${reward.expReward}\n'
          '資源：${reward.itemRewards}';
    });
  }

  Future<void> _testCardUpgrade() async {
    if (_cardManager.collectedCards.isEmpty) {
      setState(() {
        _testResult = '請先收集一張卡片';
      });
      return;
    }

    final card = _cardManager.collectedCards.first;
    final success = await _cardManager.upgradeCard(card);

    setState(() {
      _testResult = success
          ? '卡片升級成功！\n'
              '等級：${card.level}\n'
              '經驗值：${_cardManager.experience}'
          : '升級失敗，可能是經驗值不足或已達到最高等級';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('系統測試'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '卡片系統測試',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _testCardCollection,
                      child: const Text('收集測試卡片'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _testCardUpgrade,
                      child: const Text('升級卡片'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '成就系統測試',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _testAchievement,
                      child: const Text('領取成就獎勵'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '測試結果',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_testResult),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
