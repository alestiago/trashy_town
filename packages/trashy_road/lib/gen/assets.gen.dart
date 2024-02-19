/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

class $AssetsAudioGen {
  const $AssetsAudioGen();

  /// File path: assets/audio/plastic_bottle.mp3
  String get plasticBottle => 'assets/audio/plastic_bottle.mp3';

  /// List of all assets
  List<String> get values => [plasticBottle];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/barrel.png
  AssetGenImage get barrel => const AssetGenImage('assets/images/barrel.png');

  /// File path: assets/images/bus.png
  AssetGenImage get bus => const AssetGenImage('assets/images/bus.png');

  /// File path: assets/images/car.png
  AssetGenImage get car => const AssetGenImage('assets/images/car.png');

  /// File path: assets/images/grass--road-east.png
  AssetGenImage get grassRoadEast =>
      const AssetGenImage('assets/images/grass--road-east.png');

  /// File path: assets/images/grass--road-southwest.png
  AssetGenImage get grassRoadSouthwest =>
      const AssetGenImage('assets/images/grass--road-southwest.png');

  /// File path: assets/images/grass-flowers.png
  AssetGenImage get grassFlowers =>
      const AssetGenImage('assets/images/grass-flowers.png');

  /// File path: assets/images/grass.png
  AssetGenImage get grass => const AssetGenImage('assets/images/grass.png');

  /// File path: assets/images/plastic_bottle-shadow.png
  AssetGenImage get plasticBottleShadow =>
      const AssetGenImage('assets/images/plastic_bottle-shadow.png');

  /// File path: assets/images/plastic_bottle.png
  AssetGenImage get plasticBottle =>
      const AssetGenImage('assets/images/plastic_bottle.png');

  /// File path: assets/images/player.png
  AssetGenImage get player => const AssetGenImage('assets/images/player.png');

  /// File path: assets/images/road.png
  AssetGenImage get road => const AssetGenImage('assets/images/road.png');

  /// File path: assets/images/trash.png
  AssetGenImage get trash => const AssetGenImage('assets/images/trash.png');

  /// File path: assets/images/trash_can-opening.png
  AssetGenImage get trashCanOpening =>
      const AssetGenImage('assets/images/trash_can-opening.png');

  /// File path: assets/images/trash_can-shadow.png
  AssetGenImage get trashCanShadow =>
      const AssetGenImage('assets/images/trash_can-shadow.png');

  /// File path: assets/images/trash_can.png
  AssetGenImage get trashCan =>
      const AssetGenImage('assets/images/trash_can.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        barrel,
        bus,
        car,
        grassRoadEast,
        grassRoadSouthwest,
        grassFlowers,
        grass,
        plasticBottleShadow,
        plasticBottle,
        player,
        road,
        trash,
        trashCanOpening,
        trashCanShadow,
        trashCan
      ];
}

class $AssetsRiveGen {
  const $AssetsRiveGen();

  /// File path: assets/rive/rating_animation.riv
  RiveGenImage get ratingAnimation =>
      const RiveGenImage('assets/rive/rating_animation.riv');

  /// List of all assets
  List<RiveGenImage> get values => [ratingAnimation];
}

class $AssetsTilesGen {
  const $AssetsTilesGen();

  /// File path: assets/tiles/Tiles.tsx
  String get tiles => 'assets/tiles/Tiles.tsx';

  /// File path: assets/tiles/barrel.tx
  String get barrel => 'assets/tiles/barrel.tx';

  /// File path: assets/tiles/map1.tmx
  String get map1 => 'assets/tiles/map1.tmx';

  /// File path: assets/tiles/map2.tmx
  String get map2 => 'assets/tiles/map2.tmx';

  /// File path: assets/tiles/road_lane.tx
  String get roadLane => 'assets/tiles/road_lane.tx';

  /// File path: assets/tiles/spawn.tx
  String get spawn => 'assets/tiles/spawn.tx';

  /// File path: assets/tiles/trash_can_glass.tx
  String get trashCanGlass => 'assets/tiles/trash_can_glass.tx';

  /// File path: assets/tiles/trash_can_plastic.tx
  String get trashCanPlastic => 'assets/tiles/trash_can_plastic.tx';

  /// File path: assets/tiles/trash_glass.tx
  String get trashGlass => 'assets/tiles/trash_glass.tx';

  /// File path: assets/tiles/trash_plastic.tx
  String get trashPlastic => 'assets/tiles/trash_plastic.tx';

  /// List of all assets
  List<String> get values => [
        tiles,
        barrel,
        map1,
        map2,
        roadLane,
        spawn,
        trashCanGlass,
        trashCanPlastic,
        trashGlass,
        trashPlastic
      ];
}

class Assets {
  Assets._();

  static const $AssetsAudioGen audio = $AssetsAudioGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsRiveGen rive = $AssetsRiveGen();
  static const $AssetsTilesGen tiles = $AssetsTilesGen();
  static const String trashyRoadTiledProject =
      'assets/trashy_road.tiled-project';
  static const String trashyRoadTiledSession =
      'assets/trashy_road.tiled-session';

  /// List of all assets
  static List<String> get values =>
      [trashyRoadTiledProject, trashyRoadTiledSession];
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class RiveGenImage {
  const RiveGenImage(this._assetName);

  final String _assetName;

  RiveAnimation rive({
    String? artboard,
    List<String> animations = const [],
    List<String> stateMachines = const [],
    BoxFit? fit,
    Alignment? alignment,
    Widget? placeHolder,
    bool antialiasing = true,
    List<RiveAnimationController> controllers = const [],
    OnInitCallback? onInit,
  }) {
    return RiveAnimation.asset(
      _assetName,
      artboard: artboard,
      animations: animations,
      stateMachines: stateMachines,
      fit: fit,
      alignment: alignment,
      placeHolder: placeHolder,
      antialiasing: antialiasing,
      controllers: controllers,
      onInit: onInit,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
