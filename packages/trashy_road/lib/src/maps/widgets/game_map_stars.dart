import 'package:flutter/material.dart';

class GameMapStars extends StatelessWidget {
  const GameMapStars({
    required this.stars,
    super.key,
  });

  /// The number of stars to show as filled.
  ///
  /// The maximum value is 3.
  final int stars;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++) _Star(filled: i < stars),
      ],
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({
    required this.filled,
  });

  final bool filled;

  @override
  Widget build(BuildContext context) {
    const emptyStar = '☆';
    const fullStar = '★';

    return Text(
      filled ? fullStar : emptyStar,
      style: TextStyle(
        fontSize: 24,
        color: filled ? Colors.yellow : Colors.grey,
      ),
    );
  }
}
