import 'package:flutter/material.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ScorePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score'),
      ),
      body: const Center(
        child: Text('Score Page'),
      ),
    );
  }
}
