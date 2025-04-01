import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/enums.dart';

class CardFrontView extends StatefulWidget {
  final CardModel card;
  final double? height;
  final VoidCallback? onTap;

  const CardFrontView({
    super.key,
    required this.card,
    this.height,
    this.onTap,
  });

  @override
  State<CardFrontView> createState() => _CardFrontViewState();
}

class _CardFrontViewState extends State<CardFrontView>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Color _getRankColor(CardRank rank) {
    return switch (rank) {
      CardRank.N => Colors.grey.shade400,
      CardRank.R => Colors.blue.shade400,
      CardRank.SR => Colors.purple.shade400,
      CardRank.SSR => Colors.orange.shade400,
    };
  }

  IconData _getCardIcon(String name) {
    if (name.contains('程序員')) return Icons.code;
    if (name.contains('設計師')) return Icons.brush;
    if (name.contains('經理')) return Icons.business;
    if (name.contains('營銷')) return Icons.trending_up;
    return Icons.person;
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final rankColor = _getRankColor(card.rank);
    final cardIcon = _getCardIcon(card.name);
    final height = widget.height ?? 400.0;
    final width = height * 0.7;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              rankColor.withOpacity(0.8),
              rankColor.withOpacity(0.6),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: rankColor.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // 背景網格
            CustomPaint(
              size: Size(width, height),
              painter: CardBackgroundPainter(color: rankColor),
            ),
            // SSR卡片閃光效果
            if (card.rank == CardRank.SSR)
              AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(width, height),
                    painter: ShimmerEffect(
                      color: Colors.white,
                      progress: _shimmerController.value,
                    ),
                  );
                },
              ),
            // 卡片內容
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 稀有度標籤
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      card.rank.toString().split('.').last,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // 卡片圖標
                  Icon(
                    cardIcon,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  // 卡片名稱
                  Text(
                    card.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 等級和突破
                  Row(
                    children: [
                      Text(
                        'Lv.${card.level}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      ...List.generate(
                        card.maxBreakthrough,
                        (index) => Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.star,
                            size: 16,
                            color: index < card.breakthrough
                                ? Colors.amber
                                : Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
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
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 30.0;
    final rows = (size.height / spacing).ceil();
    final cols = (size.width / spacing).ceil();

    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        final path = Path();
        final x = j * spacing;
        final y = i * spacing;

        path.moveTo(x, y);
        path.lineTo(x + spacing, y);
        path.lineTo(x + spacing / 2, y + spacing);
        path.close();

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ShimmerEffect extends CustomPainter {
  final Color color;
  final double progress;

  ShimmerEffect({
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withOpacity(0),
          color.withOpacity(0.5),
          color.withOpacity(0),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(math.pi * 2 * progress),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ShimmerEffect oldDelegate) {
    return oldDelegate.progress != progress;
  }
} 