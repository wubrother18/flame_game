import 'dart:math';
import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final VoidCallback? onFlip;
  final Duration duration;
  final double perspective;
  final Axis flipDirection;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    this.onFlip,
    this.duration = const Duration(milliseconds: 800),
    this.perspective = 0.002,
    this.flipDirection = Axis.horizontal,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  bool _isFrontVisible = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuad,
      ),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_controller.isAnimating) return;
    widget.onFlip?.call();
    if (_isFrontVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFrontVisible = !_isFrontVisible;
  }

  @override
  Widget build(BuildContext context) {
    final isHorizontal = widget.flipDirection == Axis.horizontal;
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, widget.perspective)
            ..rotateY(isHorizontal ? angle : 0)
            ..rotateX(isHorizontal ? 0 : angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: _isFrontVisible ^ (_animation.value >= 0.5)
                ? widget.front
                : Transform(
                    transform: Matrix4.identity()
                      ..rotateY(isHorizontal ? pi : 0)
                      ..rotateX(isHorizontal ? 0 : pi),
                    alignment: Alignment.center,
                    child: widget.back,
                  ),
          );
        },
      ),
    );
  }
} 