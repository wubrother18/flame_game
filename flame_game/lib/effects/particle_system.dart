import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame_game/model/enums.dart';

class ParticleSystem extends StatefulWidget {
  final CardRank rank;
  final Widget child;

  const ParticleSystem({
    super.key,
    required this.rank,
    required this.child,
  });

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // 根據稀有度生成不同數量和類型的粒子
    _generateParticles();

    _controller.addListener(() {
      for (var particle in _particles) {
        particle.update();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateParticles() {
    _particles.clear();
    int count = switch (widget.rank) {
      CardRank.SSR => 50,
      CardRank.SR => 30,
      CardRank.R => 20,
      CardRank.N => 10,
    };

    Color baseColor = switch (widget.rank) {
      CardRank.SSR => Colors.amber,
      CardRank.SR => Colors.blue,
      CardRank.R => Colors.green,
      CardRank.N => Colors.grey,
    };

    for (int i = 0; i < count; i++) {
      _particles.add(Particle(
        random: _random,
        baseColor: baseColor,
        rank: widget.rank,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            rank: widget.rank,
          ),
          size: Size.infinite,
        ),
      ],
    );
  }
}

class Particle {
  double x = 0;
  double y = 0;
  double speed = 0;
  double theta = 0;
  double size = 0;
  Color color;
  final Random random;
  final CardRank rank;

  Particle({
    required this.random,
    required Color baseColor,
    required this.rank,
  }) : color = baseColor {
    _init();
  }

  void _init() {
    // 根據稀有度設置不同的粒子參數
    double maxSize = switch (rank) {
      CardRank.SSR => 4.0,
      CardRank.SR => 3.0,
      CardRank.R => 2.0,
      CardRank.N => 1.0,
    };

    x = random.nextDouble() * 400;
    y = random.nextDouble() * 800;
    speed = random.nextDouble() * 2 + 1;
    theta = random.nextDouble() * pi * 2;
    size = random.nextDouble() * maxSize;

    // 為SSR卡添加特殊效果
    if (rank == CardRank.SSR) {
      color = HSLColor.fromColor(color)
        .withLightness(random.nextDouble() * 0.5 + 0.5)
        .toColor();
    }
  }

  void update() {
    x += cos(theta) * speed;
    y += sin(theta) * speed;

    // 粒子超出範圍時重置
    if (x < 0 || x > 400 || y < 0 || y > 800) {
      _init();
    }

    // SSR卡的粒子會閃爍
    if (rank == CardRank.SSR) {
      color = color.withOpacity(random.nextDouble() * 0.5 + 0.5);
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final CardRank rank;

  ParticlePainter({
    required this.particles,
    required this.rank,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      // 為不同稀有度添加不同的粒子形狀
      switch (rank) {
        case CardRank.SSR:
          // 星形
          _drawStar(canvas, particle.x, particle.y, particle.size, paint);
        case CardRank.SR:
          // 菱形
          _drawDiamond(canvas, particle.x, particle.y, particle.size, paint);
        case CardRank.R:
          // 圓形
          canvas.drawCircle(
            Offset(particle.x, particle.y),
            particle.size,
            paint,
          );
        case CardRank.N:
          // 方形
          canvas.drawRect(
            Rect.fromCircle(
              center: Offset(particle.x, particle.y),
              radius: particle.size,
            ),
            paint,
          );
      }
    }
  }

  void _drawStar(Canvas canvas, double x, double y, double size, Paint paint) {
    final path = Path();
    final double radius = size * 2;
    const int spikes = 5;
    const double innerRadius = 0.4;

    for (int i = 0; i < spikes * 2; i++) {
      double r = (i % 2 == 0) ? radius : radius * innerRadius;
      double angle = (i * pi) / spikes;
      double px = x + cos(angle) * r;
      double py = y + sin(angle) * r;
      
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawDiamond(Canvas canvas, double x, double y, double size, Paint paint) {
    final path = Path();
    path.moveTo(x, y - size);
    path.lineTo(x + size, y);
    path.lineTo(x, y + size);
    path.lineTo(x - size, y);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 