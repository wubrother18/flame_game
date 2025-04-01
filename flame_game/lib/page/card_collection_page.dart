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
  String _sortBy = '等級';
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

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected != isSelected) {
          onSelected();
        }
      },
      backgroundColor: Colors.white.withOpacity(0.8),
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
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
                                child: card.image != null && card.image!.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                                        child: Image.asset(
                                          card.image!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              _getCardIcon(card.name),
                                              size: 64,
                                              color: Colors.white.withOpacity(0.9),
                                            );
                                          },
                                        ),
                                      )
                                    : Icon(
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
                              Positioned(
                                bottom: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.amber.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Lv. ${card.level}',
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
                                    ],
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
                            children: [
                              Text(
                                card.name,
                                style: TextStyle(
                                  fontSize: Responsive.getFontSize(context, 16),
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
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    _getCardIcon(card.name),
                                    size: 16,
                                    color: AppTheme.textLightColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    card.name.split(' ').last,
                                    style: TextStyle(
                                      fontSize: Responsive.getFontSize(context, 14),
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
    if (name.contains('工程')) {
      return Icons.code;
    } else if (name.contains('設計')) {
      return Icons.palette;
    } else if (name.contains('經理')) {
      return Icons.assignment;
    } else if (name.contains('行銷')) {
      return Icons.trending_up;
    } else {
      return Icons.person;
    }
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
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('全部'),
                        ),
                        ...CardRank.values.map((rank) {
                          return DropdownMenuItem(
                            value: rank,
                            child: Text(rank.name),
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
    return _cardManager.collectedCards.where((card) {
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
                            color: _getRankColor(card.rank),
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