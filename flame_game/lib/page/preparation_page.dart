import 'package:flutter/material.dart';
import 'package:flame_game/widgets/sci_fi_background.dart';
import 'package:flame_game/manager/card_manager.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/enums.dart';
import 'package:flame_game/page/game_page.dart';

class PreparationPage extends StatefulWidget {
  const PreparationPage({super.key});

  @override
  State<PreparationPage> createState() => _PreparationPageState();
}

class _PreparationPageState extends State<PreparationPage> {
  final CardManager _cardManager = CardManager.instance;
  final List<CardModel> _selectedCards = [];
  final int _maxSelectedCards = 5;

  @override
  Widget build(BuildContext context) {
    return SciFiBackground(
      primaryColor: const Color(0xFF2E1A2E),
      secondaryColor: const Color(0xFF3E163E),
      accentColor: const Color(0xFF600F60),
      gridSize: 25,
      lineWidth: 1,
      glowIntensity: 0.5,
      gradientColors: [
        const Color(0xFF2E1A2E),
        const Color(0xFF3E163E),
        const Color(0xFF600F60),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            '遊戲準備',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Color(0xFF600F60),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '已選擇卡片: ${_selectedCards.length}/$_maxSelectedCards',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_selectedCards.length == _maxSelectedCards)
                    ElevatedButton(
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('開始遊戲'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _cardManager.collectedCards.length,
                itemBuilder: (context, index) {
                  final card = _cardManager.collectedCards[index];
                  return _buildCardItem(card);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem(CardModel card) {
    final isSelected = _selectedCards.contains(card);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCards.remove(card);
          } else if (_selectedCards.length < _maxSelectedCards) {
            _selectedCards.add(card);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.purple.withOpacity(0.8)
                : _getRankColor(card.rank).withOpacity(0.5),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.purple.withOpacity(0.3)
                  : _getRankColor(card.rank).withOpacity(0.3),
              blurRadius: isSelected ? 15 : 10,
              spreadRadius: isSelected ? 3 : 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    image: DecorationImage(
                      image: AssetImage(card.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getRankColor(card.rank).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          card.rank.name,
                          style: TextStyle(
                            color: _getRankColor(card.rank),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lv.${card.level}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(CardRank rank) {
    return switch (rank) {
      CardRank.N => Colors.grey,
      CardRank.R => Colors.blue,
      CardRank.SR => Colors.purple,
      CardRank.SSR => Colors.orange,
    };
  }

  void _startGame() {
    if (_selectedCards.length != _maxSelectedCards) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(selectedCards: _selectedCards),
      ),
    );
  }
} 