import 'package:flame_game/manager/achieve_manager.dart';
import 'package:flutter/material.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/page/card_collection_page.dart';
import 'package:flame_game/page/prepare_page.dart';
import 'package:flame_game/manager/card_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame_game/theme/app_theme.dart';
import 'package:flame_game/utils/responsive.dart';
import 'package:flame_game/model/enums.dart';
import 'package:flame_game/widgets/sci_fi_background.dart';
import 'package:flame_game/page/gacha_page.dart';
import 'package:flame_game/page/game_page.dart';
import 'package:flame_game/page/preparation_page.dart';

import '../manager/achievement_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final CardManager _cardManager = CardManager.instance;
  List<CardModel> _displayedCards = [];
  bool _isTutorialShown = false;
  int completeAchieve = 0;
  int achieveLength = 0;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _checkTutorial();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _checkTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    _isTutorialShown = prefs.getBool('tutorial_shown') ?? false;
    await _cardManager.init();
    _loadCards();
  }

  Future<void> _loadCards() async {
    List list = await AchievementManager.instance.getCompletedAchievements();
    completeAchieve = list.length;
    achieveLength = AchievementManager.instance.getAchievements().length;
      _displayedCards = _cardManager.collectedCards;
    setState(() {});
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 24),
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
              shadows: [
                Shadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 14),
              color: AppTheme.textLightColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCardPreview(CardModel card) {
    return MouseRegion(
      onEnter: (_) => _animationController.forward(),
      onExit: (_) => _animationController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: 8,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/card_detail', arguments: card);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getRankColor(card.rank).withOpacity(0.8),
                    _getRankColor(card.rank).withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              ),
              child: Stack(
                children: [
                  // 背景圖案
                  Positioned.fill(
                    child: CustomPaint(
                      painter: CardBackgroundPainter(
                        color: _getRankColor(card.rank).withOpacity(0.1),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(AppTheme.borderRadius),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  _getCardIcon(card.name),
                                  size: 64,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white24,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    card.rank.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(AppTheme.borderRadius),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                card.name,
                                style: TextStyle(
                                  fontSize: Responsive.getFontSize(context, 14),
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black12,
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.star,
                                      size: 12,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Lv. ${card.level}',
                                    style: TextStyle(
                                      fontSize: Responsive.getFontSize(context, 12),
                                      color: AppTheme.textLightColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getRankColor(CardRank rank) {
    return switch (rank) {
      CardRank.SSR => Colors.amber.shade700,
      CardRank.SR => Colors.blue.shade700,
      CardRank.R => Colors.green.shade700,
      CardRank.N => Colors.grey.shade700,
    };
  }

  IconData _getCardIcon(String name) {
    if (name.contains('程式設計師')) {
      return Icons.code;
    } else if (name.contains('設計師')) {
      return Icons.palette;
    } else if (name.contains('專案經理')) {
      return Icons.assignment;
    } else if (name.contains('行銷專員')) {
      return Icons.trending_up;
    } else {
      return Icons.person;
    }
  }

  Widget _buildRecentCards() {
    final recentCards = _cardManager.collectedCards
        .where((card) => card.collectedAt != null)
        .toList()
      ..sort((a, b) => b.collectedAt!.compareTo(a.collectedAt!));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Responsive.getPagePadding(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '最近收集的卡片',
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, 20),
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                  shadows: [
                    Shadow(
                      color: Colors.black12,
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/collection');
                },
                icon: const Icon(Icons.visibility),
                label: const Text('查看全部'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: recentCards.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.collections_bookmark,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '還沒有收集任何卡片',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '快去抽卡或完成事件來收集卡片吧！',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: Responsive.getPagePadding(context),
                  scrollDirection: Axis.horizontal,
                  itemCount: recentCards.length.clamp(0, 5),
                  itemBuilder: (context, index) {
                    final card = recentCards[index];
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 16),
                      child: _buildCardPreview(card),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = _cardManager.getCardStats();
    
    return SciFiBackground(
      primaryColor: const Color(0xFF1A1A2E),
      secondaryColor: const Color(0xFF16213E),
      accentColor: const Color(0xFF0F3460),
      gridSize: 40,
      lineWidth: 1.5,
      glowIntensity: 0.7,
      gradientColors: [
        const Color(0xFF1A1A2E),
        const Color(0xFF16213E),
        const Color(0xFF0F3460),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '30天後',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Color(0xFF0F3460),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: [
                      _buildMenuCard(
                        context,
                        '卡片收藏',
                        Icons.collections,
                        const Color(0xFF4A90E2),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CardCollectionPage()),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        '轉蛋抽卡',
                        Icons.card_giftcard,
                        const Color(0xFFE24A4A),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GachaPage()),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        '遊戲準備',
                        Icons.settings,
                        const Color(0xFF4AE24A),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PreparationPage()),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        '開始遊戲',
                        Icons.play_arrow,
                        const Color(0xFFE2E24A),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GamePage(
                              selectedCards: [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
              shadows: [
                Shadow(
                  color: color.withOpacity(0.5),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: color.withOpacity(0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardBackgroundPainter extends CustomPainter {
  final Color color;

  CardBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();
    final width = size.width;
    final height = size.height;

    // 繪製裝飾性線條
    for (var i = 0; i < 3; i++) {
      path.moveTo(0, height * (i + 1) / 4);
      path.lineTo(width, height * (i + 1) / 4);
    }

    // 繪製對角線
    path.moveTo(0, 0);
    path.lineTo(width, height);
    path.moveTo(width, 0);
    path.lineTo(0, height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 