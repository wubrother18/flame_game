import 'package:flutter/material.dart';

class ScrollableListWrapper extends StatelessWidget {
  final Widget child;
  final String scrollHint;
  final bool showScrollIndicator;

  const ScrollableListWrapper({
    Key? key,
    required this.child,
    this.scrollHint = "往下滑動查看更多",
    this.showScrollIndicator = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: child,
        ),
        if (showScrollIndicator)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  scrollHint,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
} 