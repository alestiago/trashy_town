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
  completed;
}

/// {@template TutorialHud}
/// Displays tutorial information based on the current game state.
/// {@endtemplate}
class TutorialHud extends StatefulWidget {
  /// {@macro TutorialHud}
  const TutorialHud({super.key});

  @override
  State<TutorialHud> createState() => _TutorialHudState();
}

class _TutorialHudState extends State<TutorialHud> {
  var _tutorialStatus = _TutorialStatus.movement;

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

          late final _TutorialStatus newTutorialStatus;
          if (_tutorialStatus == _TutorialStatus.movement && hasMoved) {
            newTutorialStatus = _TutorialStatus.trashCollection;
          } else if (_tutorialStatus == _TutorialStatus.trashCollection &&
              hasCollectedTrash) {
            newTutorialStatus = _TutorialStatus.trashDeposit;
          } else if (_tutorialStatus == _TutorialStatus.trashDeposit &&
              hasDepositedTrash) {
            newTutorialStatus = _TutorialStatus.completed;
          } else {
            newTutorialStatus = _TutorialStatus.completed;
          }

          final hasChangedStatus = newTutorialStatus != _tutorialStatus;
          if (hasChangedStatus) {
            _tutorialStatus = newTutorialStatus;
          }

          return hasChangedStatus;
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
