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
      CardRank.L => Colors.purple.shade900,
      CardRank.UR => Colors.purple.shade700,
      CardRank.SSR => Colors.orange.shade400,
      CardRank.SR => Colors.purple.shade400,
      CardRank.R => Colors.blue.shade400,
      CardRank.N => Colors.grey.shade400,
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
    final width = MediaQuery.of(context).size.width * 0.8;
    final height = width * 1.4;

    return Stack(
      children: [
        // 背景網格
        CustomPaint(
          size: Size(width, height),
          painter: CardBackgroundPainter(color: rankColor),
        ),
        // 卡片內容
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: card.rank == CardRank.L
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFD700), // 金色
                      Color(0xFFFFA500), // 橙色
                      Color(0xFFFFD700), // 金色
                    ],
                    stops: [0.0, 0.5, 1.0],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      rankColor.withOpacity(0.8),
                      rankColor.withOpacity(0.6),
                    ],
                  ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: card.rank == CardRank.L
                  ? const Color(0xFFFFD700)
                  : rankColor,
              width: card.rank == CardRank.L ? 3 : 2,
            ),
            boxShadow: card.rank == CardRank.L
                ? [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: const Color(0xFFFFA500).withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: rankColor.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 卡片名稱
              Text(
                card.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: card.rank == CardRank.L ? Colors.white : Colors.white,
                  shadows: card.rank == CardRank.L
                      ? [
                          const Shadow(
                            color: Color(0xFFFFD700),
                            offset: Offset(0, 0),
                            blurRadius: 10,
                          ),
                          const Shadow(
                            color: Color(0xFFFFA500),
                            offset: Offset(0, 0),
                            blurRadius: 20,
                          ),
                        ]
                      : [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                ),
              ),
              const SizedBox(height: 20),
              // 卡片圖片
              Container(
                width: width * 0.8,
                height: width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: card.rank == CardRank.L
                        ? const Color(0xFFFFD700)
                        : Colors.white.withOpacity(0.3),
                    width: card.rank == CardRank.L ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getCardIcon(card.name),
                    size: width * 0.4,
                    color: card.rank == CardRank.L
                        ? const Color(0xFFFFD700)
                        : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 卡片等級
              Text(
                'Lv. ${card.level}',
                style: TextStyle(
                  fontSize: 18,
                  color: card.rank == CardRank.L ? Colors.white : Colors.white,
                  shadows: card.rank == CardRank.L
                      ? [
                          const Shadow(
                            color: Color(0xFFFFD700),
                            offset: Offset(0, 0),
                            blurRadius: 10,
                          ),
                        ]
                      : [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                ),
              ),
            ],
          ),
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
        // UR卡片特效
        if (card.rank == CardRank.UR)
          Stack(
            children: [
              // 彩虹光環
              AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(width, height),
                    painter: RainbowHaloEffect(
                      progress: _shimmerController.value,
                    ),
                  );
                },
              ),
              // 粒子效果
              AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(width, height),
                    painter: ParticleEffect(
                      progress: _shimmerController.value,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        // L卡片特效
        if (card.rank == CardRank.L)
          Stack(
            children: [
              // 神聖光環效果
              AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(width, height),
                    painter: HolyHaloEffect(
                      progress: _shimmerController.value,
                    ),
                  );
                },
              ),
              // 粒子效果
              AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(width, height),
                    painter: LegendaryParticleEffect(
                      progress: _shimmerController.value,
                      color: const Color(0xFFFFD700),
                    ),
                  );
                },
              ),
              // 閃光效果
              AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(width, height),
                    painter: ShimmerEffect(
                      color: const Color(0xFFFFD700),
                      progress: _shimmerController.value,
                    ),
                  );
                },
              ),
            ],
          ),
      ],
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

class RainbowHaloEffect extends CustomPainter {
  final double progress;

  RainbowHaloEffect({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.6;
    
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          Colors.indigo,
          Colors.purple,
          Colors.red,
        ],
        transform: GradientRotation(math.pi * 2 * progress),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GoldenHaloEffect extends CustomPainter {
  final double progress;

  GoldenHaloEffect({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.6;
    
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.amber,
          Colors.amber.shade700,
          Colors.amber.shade900,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticleEffect extends CustomPainter {
  final double progress;
  final Color color;

  ParticleEffect({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // 增加粒子數量
    for (var i = 0; i < 12; i++) {
      final angle = (i / 12) * math.pi * 2 + progress * math.pi * 2;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;
      
      // 粒子大小變化
      final particleSize = 4.0 + 2.0 * math.sin(progress * math.pi * 4 + i * 0.3);
      
      canvas.drawCircle(
        Offset(x, y),
        particleSize,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LegendaryParticleEffect extends CustomPainter {
  final double progress;
  final Color color;

  LegendaryParticleEffect({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    // 定義多種顏色
    final colors = [
      const Color(0xFFFFD700), // 金色
      const Color(0xFFFFA500), // 橙色
      const Color(0xFFFF4500), // 橙紅色
      const Color(0xFFFF69B4), // 粉紅色
      const Color(0xFFFF1493), // 深粉紅色
      const Color(0xFFFF00FF), // 洋紅色
    ];

    // 增加粒子數量
    for (var i = 0; i < 24; i++) {
      final random = math.Random(i);
      final colorIndex = random.nextInt(colors.length);
      final particleColor = colors[colorIndex];
      
      final paint = Paint()
        ..color = particleColor.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      // 計算粒子的位置和大小
      final angle = (i / 24) * math.pi * 2 + progress * math.pi * 2;
      // 使用指數函數讓粒子向外爆發
      final distance = radius * math.pow(progress, 2) * 2;
      final x = center.dx + math.cos(angle) * distance;
      final y = center.dy + math.sin(angle) * distance;
      
      // 粒子大小變化
      final particleSize = 6.0 + 4.0 * math.sin(progress * math.pi * 4 + i * 0.2);
      
      // 繪製粒子
      canvas.drawCircle(
        Offset(x, y),
        particleSize,
        paint,
      );

      // 添加粒子拖尾
      final tailLength = particleSize * 3;
      final tailPaint = Paint()
        ..color = particleColor.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final tailPath = Path()
        ..moveTo(x, y)
        ..lineTo(
          x - math.cos(angle) * tailLength,
          y - math.sin(angle) * tailLength,
        );
      
      canvas.drawPath(tailPath, tailPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GoldenGlowEffect extends CustomPainter {
  final double progress;

  GoldenGlowEffect({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.6;
    
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFD700).withOpacity(0.8),
          const Color(0xFFFFA500).withOpacity(0.6),
          const Color(0xFFFFD700).withOpacity(0.4),
          const Color(0xFFFFA500).withOpacity(0.2),
          const Color(0xFFFFD700).withOpacity(0.0),
        ],
        stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HolyHaloEffect extends CustomPainter {
  final double progress;

  HolyHaloEffect({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.7;
    
    // 主光環
    final mainPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFD700).withOpacity(0.8),
          const Color(0xFFFFA500).withOpacity(0.6),
          const Color(0xFFFFD700).withOpacity(0.4),
          const Color(0xFFFFA500).withOpacity(0.2),
          const Color(0xFFFFD700).withOpacity(0.0),
        ],
        stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, mainPaint);

    // 神聖光環
    final haloPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          const Color(0xFFFFD700).withOpacity(0.8),
          const Color(0xFFFFA500).withOpacity(0.6),
          const Color(0xFFFFD700).withOpacity(0.8),
        ],
        transform: GradientRotation(math.pi * 2 * progress),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawCircle(center, radius, haloPaint);

    // 破碎效果
    final crackPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var i = 0; i < 12; i++) {
      final angle = (i / 12) * math.pi * 2 + progress * math.pi;
      final startX = center.dx + math.cos(angle) * radius * 0.7;
      final startY = center.dy + math.sin(angle) * radius * 0.7;
      final endX = center.dx + math.cos(angle) * radius * 1.3;
      final endY = center.dy + math.sin(angle) * radius * 1.3;
      
      final path = Path()
        ..moveTo(startX, startY)
        ..lineTo(endX, endY);
      
      canvas.drawPath(path, crackPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 