import 'package:basura/basura.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';

enum _TutorialStatus {
  /// The user is learning how to move the player.
  movement,

  /// The user is learning how to collect trash.
  trashCollection,

  /// The user is learning how to deposit trash.
  trashDeposit,

  /// The tutorial has been completed.
  completed,
}

/// {@template GameTutorial}
/// Displays tutorial information based on the current game state.
/// {@endtemplate}
class GameTutorial extends StatefulWidget {
  /// {@macro GameTutorial}
  const GameTutorial({super.key});

  @override
  State<GameTutorial> createState() => _GameTutorialState();
}

class _GameTutorialState extends State<GameTutorial> {
  _TutorialStatus _tutorialStatus = _TutorialStatus.movement;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: BasuraTheme.of(context).textTheme.cardSubheading,
      child: BlocBuilder<GameBloc, GameState>(
        buildWhen: (previous, current) {
          final hasMoved = previous.status == GameStatus.ready &&
              current.status == GameStatus.playing;
          final hasCollectedTrash = previous.inventory.items.isEmpty &&
              current.inventory.items.isNotEmpty;
          final hasDepositedTrash =
              previous.collectedTrash < current.collectedTrash;

          if (_tutorialStatus == _TutorialStatus.movement && hasMoved) {
            _tutorialStatus = _TutorialStatus.trashCollection;
          } else if (_tutorialStatus == _TutorialStatus.trashCollection &&
              hasCollectedTrash) {
            _tutorialStatus = _TutorialStatus.trashDeposit;
          } else if (_tutorialStatus == _TutorialStatus.trashDeposit &&
              hasDepositedTrash) {
            _tutorialStatus = _TutorialStatus.completed;
          } else {
            return false;
          }

          return true;
        },
        builder: (context, state) {
          switch (_tutorialStatus) {
            case _TutorialStatus.movement:
              return const _MovementInformation();
            case _TutorialStatus.trashCollection:
              return const _TrashCollectionInformation();
            case _TutorialStatus.trashDeposit:
              return const _TrashDepositInformation();
            case _TutorialStatus.completed:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

/// {@template _MovementInformation}
/// Displays information about how to move the player.
/// {@endtemplate}
class _MovementInformation extends StatelessWidget {
  /// {@macro _MovementInformation}
  const _MovementInformation();

  @override
  Widget build(BuildContext context) {
    return Assets.images.display.tutorialMovement.image(
      width: 300,
      filterQuality: FilterQuality.medium,
      opacity: const AlwaysStoppedAnimation(0.5),
    );
  }
}

/// {@template _TrashCollectionInformation}
/// Displays information about how to collect trash.
/// {@endtemplate}
class _TrashCollectionInformation extends StatelessWidget {
  /// {@macro _TrashCollectionInformation}
  const _TrashCollectionInformation();

  @override
  Widget build(BuildContext context) {
    return Assets.images.display.tutorialCollectTrash.image(
      width: 300,
      filterQuality: FilterQuality.medium,
      opacity: const AlwaysStoppedAnimation(0.5),
    );
  }
}

/// {@template _TrashDepositInformation}
/// Displays information about how to deposit trash.
/// {@endtemplate}
class _TrashDepositInformation extends StatelessWidget {
  /// {@macro _TrashDepositInformation}
  const _TrashDepositInformation();

  @override
  Widget build(BuildContext context) {
    return Assets.images.display.tutorialDepositTrash.image(
      width: 300,
      filterQuality: FilterQuality.medium,
      opacity: const AlwaysStoppedAnimation(0.5),
    );
  }
}
