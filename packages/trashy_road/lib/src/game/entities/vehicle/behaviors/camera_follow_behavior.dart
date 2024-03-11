import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:trashy_road/game_settings.dart';

/// {@template CameraFollowBehavior}
/// An adaptation of [FollowBehavior] that makes some vertical adjustments so
/// that the [target] is not directly at the center of the screen.
/// {@endtemplate}
class CameraFollowBehavior extends Component with HasGameReference {
  /// {@macro CameraFollowBehavior}
  CameraFollowBehavior({
    required ReadOnlyPositionProvider target,
    required this.viewport,
    PositionProvider? owner,
    double maxSpeed = double.infinity,
    super.priority,
  })  : _target = target,
        _owner = owner,
        _speed = maxSpeed,
        assert(maxSpeed > 0, 'maxSpeed must be positive: $maxSpeed');

  ReadOnlyPositionProvider get target => _target;
  final ReadOnlyPositionProvider _target;

  PositionProvider get owner => _owner!;
  PositionProvider? _owner;

  double get maxSpeed => _speed;
  final double _speed;

  final Viewport viewport;

  @override
  void onMount() {
    if (_owner == null) {
      assert(
        parent is PositionProvider,
        'Can only apply this behavior to a PositionProvider',
      );
      _owner = parent! as PositionProvider;
    }
  }

  final _deltaCache = Vector2.zero();

  /// The amount of distance that the player should be away from the center of
  /// the screen.
  static final _verticalAdjustment = GameSettings.gridDimensions.y * 3;

  @override
  void update(double dt) {
    final delta = _deltaCache
      ..setFrom(target.position)
      ..sub(owner.position)
      ..y -= _verticalAdjustment;

    final distance = delta.length;
    if (distance > _speed * dt) {
      delta.scale(_speed * dt / distance);
    }
    if (delta.x != 0 || delta.y != 0) {
      owner.position = delta..add(owner.position);
    }
  }
}
