import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame_game/widgets/sci_fi_background.dart';
import 'package:flame_game/manager/card_manager.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/enums.dart';
import 'package:flame_game/manager/gacha_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame_game/theme/app_theme.dart';
import 'package:flame_game/utils/responsive.dart';

import '../static.dart';

class GachaPage extends StatefulWidget {
  const GachaPage({super.key});

  @override
  State<GachaPage> createState() => _GachaPageState();
}

class _GachaPageState extends State<GachaPage> with SingleTickerProviderStateMixin {
  final CardManager _cardManager = CardManager.instance;
  final GachaManager _gachaManager = GachaManager.instance;
  List<CardModel> _drawnCard = [];
  int _pityCounter = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isSpinning = false;
  CardModel? _currentCard;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _loadPityCounter();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPityCounter() async {
    _pityCounter = _gachaManager.pityProgress;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SciFiBackground(
      primaryColor: const Color(0xFF1A2E1A),
      secondaryColor: const Color(0xFF163E16),
      accentColor: const Color(0xFF0F600F),
      gridSize: 35,
      lineWidth: 1.5,
      glowIntensity: 0.6,
      gradientColors: [
        const Color(0xFF1A2E1A),
        const Color(0xFF163E16),
        const Color(0xFF0F600F),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            '轉蛋系統',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Color(0xFF0F600F),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildResourceItem(
                    '經驗值',
                    _cardManager.experience.toString(),
                    Icons.star,
                    Colors.amber,
                  ),
                  _buildResourceItem(
                    '寶石',
                    _cardManager.gem.toString(),
                    Icons.diamond,
                    Colors.blue,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_currentCard != null)
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: _buildCardPreview(_currentCard!),
                      ),
                    const SizedBox(height: 40),
                    _buildGachaButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardPreview(CardModel card) {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getRankColor(card.rank).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getRankColor(card.rank).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              image: DecorationImage(
                image: AssetImage(card.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
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
                const SizedBox(height: 8),
                Text(
                  card.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGachaButton() {
    return GestureDetector(
      onTap: _isSpinning ? null : _spinGacha,
      child: Container(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade400,
              Colors.green.shade600,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            _isSpinning ? '抽卡中...' : '抽卡',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
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

  Future<void> _spinGacha() async {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
      _currentCard = null;
    });

    // 播放抽卡音效
    // await FlameAudio.play('gacha.mp3');

    // 使用 CardManager 進行抽卡
    final card = await StaticFunction.instance.gachaManager.draw(GachaType.limited);
    
    if (card != null) {
      setState(() {
        _currentCard = card;
      });
      
      // 播放卡片出現音效
      // await FlameAudio.play('card_appear.mp3');
    }

    setState(() {
      _isSpinning = false;
    });
  }
}
