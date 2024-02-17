import 'package:flutter/material.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({
    required int score,
    super.key,
  }) : _score = score;

  final int _score;

  static Route<void> route({
    required int score,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ScorePage(score: score),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score'),
      ),
      body: Center(
        child: Text('Score: $_score'),
      ),
    );
  }
}
