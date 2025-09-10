import 'package:flame_game/page/card_growth_page.dart';
import 'package:flutter/material.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/manager/card_manager.dart';
import 'package:flame_game/theme/app_theme.dart';
import 'package:flame_game/utils/responsive.dart';
import 'package:flame_game/model/enums.dart';
import 'package:flame_game/widgets/sci_fi_background.dart';
import 'package:flame_game/page/card_detail_page.dart';

class CardCollectionPage extends StatefulWidget {
  const CardCollectionPage({super.key});

  @override
  State<CardCollectionPage> createState() => _CardCollectionPageState();
}

class _CardCollectionPageState extends State<CardCollectionPage> with SingleTickerProviderStateMixin {
  final CardManager _cardManager = CardManager.instance;
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = '全部';
  String _sortBy = '稀有度';
  bool _showCollectedOnly = true;
  List<CardModel> _displayedCards = [];
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String _searchQuery = '';
  CardRank? _selectedRank;

  @override
  void initState() {
    super.initState();
    _loadCards();
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
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    await _cardManager.init();
    _filterCards();
  }

  void _filterCards() {
    setState(() {
      var cards = List<CardModel>.from(_showCollectedOnly ? _cardManager.collectedCards : _cardManager.allCards);
      
      if (_searchController.text.isNotEmpty) {
        final searchText = _searchController.text.toLowerCase();
        cards = cards.where((card) => 
          card.name.toLowerCase().contains(searchText) ||
          card.rank.name.toLowerCase().contains(searchText)
        ).toList();
      }
      
      if (_selectedType != '全部') {
        cards = cards.where((card) => card.name == _selectedType).toList();
      }
      
      switch (_sortBy) {
        case '等級':
          cards.sort((a, b) {
            final levelCompare = b.level.compareTo(a.level);
            return levelCompare != 0 ? levelCompare : a.name.compareTo(b.name);
          });
          break;
        case '名稱':
          cards.sort((a, b) {
            final nameCompare = a.name.compareTo(b.name);
            return nameCompare != 0 ? nameCompare : b.level.compareTo(a.level);
          });
          break;
        case '收集時間':
          cards.sort((a, b) {
            if (a.collectedAt == null && b.collectedAt == null) return 0;
            if (a.collectedAt == null) return 1;
            if (b.collectedAt == null) return -1;
            return b.collectedAt!.compareTo(a.collectedAt!);
          });
          break;
        case '稀有度':
          cards.sort((a, b) {
            // 定義稀有度順序
            final rarityOrder = {
              CardRank.L: 7,
              CardRank.UR: 5,
              CardRank.SSR: 4,
              CardRank.SR: 3,
              CardRank.R: 2,
              CardRank.N: 1,
            };
            final rarityCompare = rarityOrder[b.rank]!.compareTo(rarityOrder[a.rank]!);
            return rarityCompare != 0 ? rarityCompare : b.level.compareTo(a.level);
          });
          break;
      }
      
      _displayedCards = cards;
    });
  }

  Color _getRankColor(CardRank rank) {
    return switch (rank) {
      CardRank.L => const Color(0xFFFFD700), // 金色
      CardRank.UR => const Color(0xFFFF00FF), // 亮紫色
      CardRank.SSR => Colors.orange,
      CardRank.SR => Colors.purple,
      CardRank.R => Colors.blue,
      CardRank.N => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SciFiBackground(
      primaryColor: const Color(0xFF2E1A1A),
      secondaryColor: const Color(0xFF3E1616),
      accentColor: const Color(0xFF600F0F),
      gridSize: 30,
      lineWidth: 1,
      glowIntensity: 0.5,
      gradientColors: [
        const Color(0xFF2E1A1A),
        const Color(0xFF3E1616),
        const Color(0xFF600F0F),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            '卡片收藏',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Color(0xFF600F0F),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          leading: IconButton(onPressed: () { Navigator.pop(context); }, icon: const Icon(Icons.arrow_back_ios,color: Colors.white, ),),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '搜索卡片...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<CardRank>(
                      value: _selectedRank,
                      hint: const Text(
                        '全部',
                        style: TextStyle(color: Colors.white),
                      ),
                      dropdownColor: const Color(0xFF2E1A1A),
                      underline: const SizedBox(),
                      style: const TextStyle(color: Colors.white),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('全部', style: TextStyle(color: Colors.white)),
                        ),
                        ...CardRank.values.map((rank) {
                          return DropdownMenuItem(
                            value: rank,
                            child: Text(rank.name, style: const TextStyle(color: Colors.white)),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedRank = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: _sortBy,
                      dropdownColor: const Color(0xFF2E1A1A),
                      underline: const SizedBox(),
                      style: const TextStyle(color: Colors.white),
                      items: const [
                        DropdownMenuItem(
                          value: '稀有度',
                          child: Text('稀有度', style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem(
                          value: '等級',
                          child: Text('等級', style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem(
                          value: '名稱',
                          child: Text('名稱', style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem(
                          value: '收集時間',
                          child: Text('收集時間', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sortBy = value!;
                          setState(() {

                          });
                        });
                      },
                    ),
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
                itemCount: _filteredCards.length,
                itemBuilder: (context, index) {
                  final card = _filteredCards[index];
                  return _buildCardItem(card);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CardModel> get _filteredCards {
    List<CardModel> tmpList = [];
    tmpList.addAll(_cardManager.collectedCards);
    switch (_sortBy) {
      case '等級':
        tmpList.sort((a, b) {
          final levelCompare = b.level.compareTo(a.level);
          return levelCompare != 0 ? levelCompare : a.name.compareTo(b.name);
        });
        break;
      case '名稱':
        tmpList.sort((a, b) {
          final nameCompare = a.name.compareTo(b.name);
          return nameCompare != 0 ? nameCompare : b.level.compareTo(a.level);
        });
        break;
      case '收集時間':
        tmpList.sort((a, b) {
          if (a.collectedAt == null && b.collectedAt == null) return 0;
          if (a.collectedAt == null) return 1;
          if (b.collectedAt == null) return -1;
          return b.collectedAt!.compareTo(a.collectedAt!);
        });
        break;
      case '稀有度':
        tmpList.sort((a, b) {
          // 定義稀有度順序
          final rarityOrder = {
            CardRank.L: 7,
            CardRank.UR: 5,
            CardRank.SSR: 4,
            CardRank.SR: 3,
            CardRank.R: 2,
            CardRank.N: 1,
          };
          final rarityCompare = rarityOrder[b.rank]!.compareTo(rarityOrder[a.rank]!);
          return rarityCompare != 0 ? rarityCompare : b.level.compareTo(a.level);
        });
        break;
    }
    return tmpList.where((card) {
      final matchesSearch = _searchQuery.isEmpty ||
          card.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          card.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRank = _selectedRank == null || card.rank == _selectedRank;
      return matchesSearch && matchesRank;
    }).toList();
  }

  Widget _buildCardItem(CardModel card) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardDetailPage(card: card),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getRankColor(card.rank).withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _getRankColor(card.rank).withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
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
                  Row(
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
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Lv.${card.level}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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