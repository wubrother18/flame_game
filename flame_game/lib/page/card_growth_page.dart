import 'package:flutter/material.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/manager/card_manager.dart';

class CardGrowthPage extends StatefulWidget {
  final CardModel card;

  const CardGrowthPage({
    super.key,
    required this.card,
  });

  @override
  State<CardGrowthPage> createState() => _CardGrowthPageState();
}

class _CardGrowthPageState extends State<CardGrowthPage> {
  late CardModel _card;
  int _expToAdd = 0;
  final CardManager _cardManager = CardManager.instance;

  @override
  void initState() {
    super.initState();
    _card = widget.card;
  }

  @override
  Widget build(BuildContext context) {
    final stats = _card.currentStats;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${_card.name} - 成長'),
        backgroundColor: _card.rarityColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 經驗值池信息
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '經驗值池',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('可用經驗值: ${_cardManager.experience}'),
                    const SizedBox(height: 16),
                    const Text('獲取經驗值的方式:'),
                    const Text('• 完成關卡 (勝利: 100+, 失敗: 50+)'),
                    const Text('• 完成每日任務 (100-200)'),
                    const Text('• 完成成就 (200-1000)'),
                    const Text('• 分解重複卡片 (100-1000+)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 卡片基本信息
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _card.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          _card.rank.name,
                          style: TextStyle(
                            color: _card.rarityColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _card.experience / _card.requiredExperience,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(_card.rarityColor),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('等級: ${_card.level}/${_card.maxLevel}'),
                        Text('經驗: ${_card.experience}/${_card.requiredExperience}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 突破信息
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '突破',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('突破等級: ${_card.breakthrough}/${_card.maxBreakthrough}'),
                        if (_card.canBreakthrough)
                          ElevatedButton(
                            onPressed: _showBreakthroughDialog,
                            child: const Text('突破'),
                          ),
                      ],
                    ),
                    if (_card.canBreakthrough) ...[
                      const SizedBox(height: 8),
                      const Text('突破所需材料:'),
                      ..._card.breakthroughMaterials.entries.map(
                        (e) => Text('${e.key}: ${e.value}'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 當前屬性
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '當前屬性',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    _buildStatRow('HP', stats['hp']!),
                    _buildStatRow('MP', stats['mp']!),
                    _buildStatRow('點數', stats['point']!),
                    _buildStatRow('創意', stats['create']!),
                    _buildStatRow('人氣', stats['popular']!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 經驗值添加
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '添加經驗值',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: '經驗值',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _expToAdd = int.tryParse(value) ?? 0;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _addExperience,
                          child: const Text('添加'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value.toString()),
        ],
      ),
    );
  }

  Future<void> _addExperience() async {
    if (_expToAdd <= 0) return;
    
    if (_expToAdd > _cardManager.experience) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('經驗值不足')),
      );
      return;
    }

    if (await _cardManager.useExperience(_expToAdd)) {
      setState(() {
        _card.addExperience(_expToAdd);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('添加經驗值成功')),
      );
    }
  }

  void _showBreakthroughDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('確認突破'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('突破所需材料:'),
            ..._card.breakthroughMaterials.entries.map(
              (e) => Text('${e.key}: ${e.value}'),
            ),
            const SizedBox(height: 16),
            const Text('確定要突破嗎？'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _card.breakthroughCard();
              });
              Navigator.pop(context);
            },
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }
} 