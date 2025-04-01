import 'package:flutter/material.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/manager/card_manager.dart';
import 'package:flame_game/theme/app_theme.dart';
import 'package:flame_game/utils/responsive.dart';
import 'package:flame_game/model/enums.dart';
import 'package:flame_game/widgets/card_front_view.dart';
import 'package:flame_game/effects/flip_card.dart';
import 'dart:math' as math;

class CardDetailPage extends StatefulWidget {
  final CardModel card;

  const CardDetailPage({
    super.key,
    required this.card,
  });

  @override
  State<CardDetailPage> createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> with SingleTickerProviderStateMixin {
  final CardManager _cardManager = CardManager.instance;
  bool _isFlipped = false;
  late CardModel _card;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _expController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _card = widget.card;
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _expController.dispose();
    super.dispose();
  }

  void _handleBreakthrough() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('確認突破'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('是否消耗以下材料進行突破？'),
            const SizedBox(height: 8),
            Text('經驗值: ${_card.breakthroughMaterials['exp']}'),
            Text('寶石: ${_card.breakthroughMaterials['gem']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('確認'),
          ),
        ],
      ),
    );

    if (result == true) {
      final hasEnoughExp = await _cardManager.useExperience(_card.breakthroughMaterials['exp'] ?? 0);
      final hasEnoughGems = await _cardManager.useGems(_card.breakthroughMaterials['gem'] ?? 0);

      if (!hasEnoughExp || !hasEnoughGems) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              !hasEnoughExp && !hasEnoughGems
                  ? '經驗值和寶石不足'
                  : !hasEnoughExp
                      ? '經驗值不足'
                      : '寶石不足',
            ),
          ),
        );
        return;
      }

      _card.breakthroughCard();
      await _cardManager.saveCollectedCards();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('突破成功！')),
        );
        setState(() {});
      }
    }
  }

  void _handleLevelUp() async {
    final expPool = _cardManager.experience;
    final maxExp = _card.getRequiredExp();
    final currentExp = _card.currentExp;
    final remainingExp = maxExp - currentExp;

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('升級'),
        content: StatefulBuilder(
          builder: (context, setState) {
            _expController.text = remainingExp.toString();
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('可用經驗值: $expPool'),
                const SizedBox(height: 8),
                Text('當前等級: ${_card.level}'),
                Text('當前經驗值: $currentExp / $maxExp'),
                const SizedBox(height: 16),
                TextField(
                  controller: _expController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '使用經驗值',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 0),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final exp = int.tryParse(_expController.text) ?? 0;
              Navigator.pop(context, exp);
            },
            child: const Text('確認'),
          ),
        ],
      ),
    );

    if (result != null && result > 0) {
      final success = await _cardManager.upgradeCard(_card, result);
      if (success) {
        setState(() {});
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('升級成功！')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('經驗值不足！')),
          );
        }
      }
    }
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 1000,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getStatColor(value),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _getStatColor(value),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatColor(int value) {
    if (value >= 800) return Colors.red;
    if (value >= 600) return Colors.orange;
    if (value >= 400) return Colors.green;
    if (value >= 200) return Colors.blue;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final expPool = _cardManager.experience;
    final canBreakthrough = _card.canBreakthrough;
    final canLevelUp = _card.canLevelUp(expPool);
    final rankColor = _card.rarityColor;

    return Scaffold(
      body: Stack(
        children: [
          // 動態背景
          Positioned.fill(
            child: CustomPaint(
              painter: SciFiBackgroundPainter(
                color: rankColor,
                cardType: _getCardType(),
              ),
            ),
          ),
          // 主內容
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 頂部導航欄
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            _card.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () async {
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.grey.shade900,
                                title: const Text('確認分解', style: TextStyle(color: Colors.white)),
                                content: const Text('確定要分解這張卡片嗎？分解後將無法恢復。', 
                                  style: TextStyle(color: Colors.white70)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('取消'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('確認'),
                                  ),
                                ],
                              ),
                            );

                            if (result == true) {
                              final success = await _cardManager.decomposeCard(_card);
                              if (success && mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 卡片視圖
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FlipCard(
                      front: CardFrontView(card: _card),
                      back: Container(
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: rankColor.withOpacity(0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: rankColor.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '經驗值進度',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: rankColor.withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: _card.currentExp / _card.getRequiredExp(),
                                    backgroundColor: Colors.white.withOpacity(0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(rankColor),
                                    minHeight: 10,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${_card.currentExp} / ${_card.getRequiredExp()}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  '突破進度',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: rankColor.withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _card.maxBreakthrough,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Icon(
                                        Icons.star,
                                        size: 30,
                                        color: index < _card.breakthrough
                                            ? rankColor
                                            : Colors.white.withOpacity(0.3),
                                        shadows: [
                                          Shadow(
                                            color: rankColor.withOpacity(0.5),
                                            blurRadius: 10,
                                            offset: const Offset(0, 2),
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
                      ),
                      onFlip: () => setState(() => _isFlipped = !_isFlipped),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 屬性面板
                  SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: rankColor.withOpacity(0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: rankColor.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '屬性',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: rankColor.withOpacity(0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildStatRow('HP', _card.currentStats['hp']!),
                            _buildStatRow('MP', _card.currentStats['mp']!),
                            _buildStatRow('點數', _card.currentStats['point']!),
                            _buildStatRow('創造力', _card.currentStats['create']!),
                            _buildStatRow('人氣', _card.currentStats['popular']!),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 操作按鈕
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: canLevelUp ? _handleLevelUp : null,
                            icon: const Icon(Icons.arrow_upward),
                            label: const Text('升級'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: rankColor,
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shadowColor: rankColor.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: canBreakthrough ? _handleBreakthrough : null,
                            icon: const Icon(Icons.auto_awesome),
                            label: const Text('突破'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: canBreakthrough ? rankColor : rankColor.withOpacity(0.3),
                              foregroundColor: Colors.white,
                              elevation: canBreakthrough ? 5 : 0,
                              shadowColor: rankColor.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCardType() {
    if (_card.name.contains('程序員')) return 'programmer';
    if (_card.name.contains('設計師')) return 'designer';
    if (_card.name.contains('經理')) return 'manager';
    if (_card.name.contains('營銷')) return 'marketer';
    return 'default';
  }
}

class SciFiBackgroundPainter extends CustomPainter {
  final Color color;
  final String cardType;

  SciFiBackgroundPainter({
    required this.color,
    required this.cardType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);

    // 繪製科技線條
    final linePaint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // 繪製網格
    const spacing = 50.0;
    for (var i = 0; i < size.width; i += spacing.toInt()) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        linePaint,
      );
    }
    for (var i = 0; i < size.height; i += spacing.toInt()) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        linePaint,
      );
    }

    // 繪製主題圖案
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // 根據卡片類型繪製不同的主題圖案
    switch (cardType) {
      case 'programmer':
        _drawCodePattern(canvas, center, radius, color);
        break;
      case 'designer':
        _drawDesignPattern(canvas, center, radius, color);
        break;
      case 'manager':
        _drawManagerPattern(canvas, center, radius, color);
        break;
      case 'marketer':
        _drawMarketingPattern(canvas, center, radius, color);
        break;
      default:
        _drawDefaultPattern(canvas, center, radius, color);
    }
  }

  void _drawCodePattern(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final rect = Rect.fromCircle(center: center, radius: radius);
    path.addRect(rect);

    // 繪製二進制代碼效果
    final random = math.Random(42);
    for (var i = 0; i < 50; i++) {
      final x = center.dx - radius + random.nextDouble() * radius * 2;
      final y = center.dy - radius + random.nextDouble() * radius * 2;
      final text = random.nextBool() ? '1' : '0';
      _drawText(canvas, text, Offset(x, y), color.withOpacity(0.2));
    }

    canvas.drawPath(path, paint);
  }

  void _drawDesignPattern(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 繪製創意圖案
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(x, y);
      canvas.drawPath(path, paint);
    }

    // 繪製曲線
    final curvePaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final path = Path();
      final startAngle = i * math.pi / 2;
      final endAngle = startAngle + math.pi / 2;
      path.addArc(
        Rect.fromCircle(center: center, radius: radius * 0.8),
        startAngle,
        math.pi / 2,
      );
      canvas.drawPath(path, curvePaint);
    }
  }

  void _drawManagerPattern(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 繪製組織結構圖
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawRect(rect, paint);

    // 繪製連接線
    final linePaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final x = center.dx + radius * 0.5 * math.cos(angle);
      final y = center.dy + radius * 0.5 * math.sin(angle);
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(x, y);
      canvas.drawPath(path, linePaint);
    }
  }

  void _drawMarketingPattern(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 繪製趨勢圖
    final path = Path();
    final rect = Rect.fromCircle(center: center, radius: radius);
    path.addRect(rect);

    // 繪製上升趨勢線
    final trendPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final trendPath = Path();
    trendPath.moveTo(center.dx - radius, center.dy + radius);
    trendPath.lineTo(center.dx + radius, center.dy - radius);
    canvas.drawPath(trendPath, trendPaint);

    canvas.drawPath(path, paint);
  }

  void _drawDefaultPattern(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 繪製基本圖案
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawRect(rect, paint);

    // 繪製對角線
    final diagonalPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final diagonalPath = Path()
      ..moveTo(center.dx - radius, center.dy - radius)
      ..lineTo(center.dx + radius, center.dy + radius)
      ..moveTo(center.dx + radius, center.dy - radius)
      ..lineTo(center.dx - radius, center.dy + radius);
    canvas.drawPath(diagonalPath, diagonalPaint);
  }

  void _drawText(Canvas canvas, String text, Offset position, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 