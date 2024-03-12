import 'package:flame/components.dart';

/// Marks a component as untraversable.
///
/// Untraversable components are not traversable by the `Player`.
mixin Untraversable on PositionComponent {
  bool untraversable = true;
}
