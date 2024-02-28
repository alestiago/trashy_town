import 'package:flame/components.dart';

class GameSpriteAnimationComponent extends SpriteAnimationComponent
    with HasGameRef {
  GameSpriteAnimationComponent.fromPath({
    required String spritePath,
    required SpriteAnimationData animationData,
    super.scale,
    super.position,
  })  : _spritePath = spritePath,
        _animationData = animationData;

  final String _spritePath;

  final SpriteAnimationData _animationData;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = await game.images.fetchOrGenerate(
      _spritePath,
      () => game.images.load(_spritePath),
    );
    animation = SpriteAnimation.fromFrameData(image, _animationData);
  }
}
