import 'package:flutter/material.dart';
import 'package:flame_game/manager/gacha_manager.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/enums.dart';
import 'package:flame_game/manager/card_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GachaPage extends StatefulWidget {
  const GachaPage({Key? key}) : super(key: key);

  @override
  State<GachaPage> createState() => _GachaPageState();
}

class _GachaPageState extends State<GachaPage>
    with SingleTickerProviderStateMixin {
  final GachaManager _gachaManager = GachaManager.instance;
  List<CardModel> _drawnCard = [];
  int _pityCounter = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _loadPityCounter();
  }

  Future<void> _loadPityCounter() async {
    _pityCounter = _gachaManager.pityProgress;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _drawCard(GachaType type,{int? times}) async {
    setState(() {
      _drawnCard.clear();
    });
    times = times ?? 1;

    try {
      while(times!>=1){
        final card = await _gachaManager.draw(type);
        await _gachaManager.saveDrawHistory(card, type);
        setState(() {
          _drawnCard.add(card);
          _pityCounter = _gachaManager.pityProgress;
        });
        times--;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('抽卡失敗：$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('抽卡系統'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPityCounter(),
              const SizedBox(height: 16),
              _buildGachaButtons(),
              const SizedBox(height: 16),
              if (_drawnCard.isNotEmpty)
                SizedBox(
                  height: 305,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _drawnCard.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildDrawnCard(_drawnCard[index]);
                    },
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPityCounter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '保底計數器',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$_pityCounter / 100',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _pityCounter / 100,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGachaButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (CardManager.instance.getCollectedCards().isNotEmpty) ...[
          Expanded(
            child: _buildGachaButton(
              '普通抽卡',
              GachaType.normal,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildGachaButton(
              '高級抽卡',
              GachaType.premium,
              Colors.purple,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildGachaButton(
              '限定抽卡',
              GachaType.limited,
              Colors.orange,
            ),
          ),
        ],
        if (CardManager.instance.getCollectedCards().isEmpty) ...[
          Expanded(
            child: _buildGachaButton(
              '新手超優待抽卡',
              GachaType.event,
              Colors.red,
              times: 5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGachaButton(String text, GachaType type, Color color,
      {int? times}) {
    return ElevatedButton(
      onPressed: () => _drawCard(type,times: times),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(text),
    );
  }

  Widget _buildDrawnCard(CardModel card) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '抽卡結果',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              card.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              card.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildCardStats(card),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStats(CardModel card) {
    final stats = card.getCurrentStats();
    return Column(
      children: [
        _buildStatRow('HP', stats['hp']!),
        _buildStatRow('MP', stats['mp']!),
        _buildStatRow('點數', stats['point']!),
        _buildStatRow('創意', stats['create']!),
        _buildStatRow('人氣', stats['popular']!),
      ],
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
}
