import 'package:flame_game/page/card_growth_page.dart';
import 'package:flutter/material.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/manager/card_manager.dart';

class CardCollectionPage extends StatefulWidget {
  const CardCollectionPage({super.key});

  @override
  State<CardCollectionPage> createState() => _CardCollectionPageState();
}

class _CardCollectionPageState extends State<CardCollectionPage> {
  final CardManager _cardManager = CardManager.instance;
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = '全部';
  String _sortBy = '等級';
  bool _showCollectedOnly = true;
  List<CardModel> _displayedCards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    await _cardManager.init();
    _filterCards();
  }

  void _filterCards() {
    setState(() {
      // 獲取基礎卡片列表
      var cards = List<CardModel>.from(_showCollectedOnly ? _cardManager.collectedCards : _cardManager.allCards);
      
      // 應用搜索過濾
      if (_searchController.text.isNotEmpty) {
        final searchText = _searchController.text.toLowerCase();
        cards = cards.where((card) => 
          card.name.toLowerCase().contains(searchText) ||
          card.rank.name.toLowerCase().contains(searchText)
        ).toList();
      }
      
      // 應用類型過濾
      if (_selectedType != '全部') {
        cards = cards.where((card) => card.name == _selectedType).toList();
      }
      
      // 應用排序
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
      }
      
      _displayedCards = cards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('卡片收藏'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade100,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: Column(
          children: [
            // 搜索和過濾區域
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '搜索卡片...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) => _filterCards(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedType,
                          decoration: InputDecoration(
                            labelText: '卡片類型',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: ['全部', '程式設計師', '設計師', '專案經理', '行銷專員']
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                            });
                            _filterCards();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _sortBy,
                          decoration: InputDecoration(
                            labelText: '排序方式',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: ['等級', '名稱', '收集時間']
                              .map((sort) => DropdownMenuItem(
                                    value: sort,
                                    child: Text(sort),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _sortBy = value!;
                            });
                            _filterCards();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _showCollectedOnly,
                        onChanged: (value) {
                          setState(() {
                            _showCollectedOnly = value!;
                          });
                          _filterCards();
                        },
                      ),
                      const Text('只顯示已收集的卡片'),
                    ],
                  ),
                ],
              ),
            ),

            // 卡片列表
            Expanded(
              child: _displayedCards.isEmpty
                  ? const Center(
                      child: Text(
                        '沒有找到符合條件的卡片',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _displayedCards.length,
                      itemBuilder: (context, index) {
                        final card = _displayedCards[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(card.image),
                              radius: 30,
                            ),
                            title: Text(card.name),
                            subtitle: Text(
                              '等級: ${card.level}\n'
                              '稀有度: ${card.rank.name}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CardGrowthPage(
                                      card: card,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem(CardModel card) {
    final isCollected = card.isCollected;
    final stats = card.getCurrentStats();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: isCollected ? () => _showCardDetails(card) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isCollected ? card.rarityColor.withOpacity(0.2) : Colors.grey.shade200,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      card.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isCollected ? card.rarityColor : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.rank.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: isCollected ? card.rarityColor.withOpacity(0.7) : Colors.grey.shade600,
                      ),
                    ),
                    if (isCollected && card.collectedAt != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '收集於: ${_formatDate(card.collectedAt!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('等級'),
                      Text(
                        card.level.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: card.rarityColor,
                        ),
                      ),
                    ],
                  ),
                  if (isCollected) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/growth',
                            arguments: card,
                          ),
                          icon: const Icon(Icons.trending_up),
                          label: const Text('成長'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: card.rarityColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showCardDetails(card),
                          icon: const Icon(Icons.info_outline),
                          label: const Text('詳情'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  void _showCardDetails(CardModel card) {
    final stats = card.getCurrentStats();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(card.name),
            Text(
              card.rank.name,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('等級: ${card.level}'),
            const SizedBox(height: 8),
            Text('HP加成: ${stats['hpAdd']}'),
            Text('MP加成: ${stats['mpAdd']}'),
            Text('專業度加成: ${stats['pointAdd']}'),
            Text('創造力加成: ${stats['createAdd']}'),
            Text('人氣加成: ${stats['popularAdd']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('關閉'),
          ),
        ],
      ),
    );
  }

  void _showUpgradeDialog(CardModel card) {
    final cost = card.getUpgradeCost();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('升級 ${card.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('當前等級: ${card.level}'),
            Text('升級後等級: ${card.level + 1}'),
            const SizedBox(height: 16),
            Text('所需資源:'),
            Text('專業度: ${cost['point']}'),
            Text('創造力: ${cost['create']}'),
            Text('人氣: ${cost['popular']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (await _cardManager.upgradeCard(card)) {
                Navigator.pop(context);
                _filterCards();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('升級成功')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('資源不足，無法升級')),
                );
              }
            },
            child: const Text('升級'),
          ),
        ],
      ),
    );
  }
} 