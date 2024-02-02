import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:trashy_road/src/game/game.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _game = TrashyRoadGame();

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _game);
  }
}
