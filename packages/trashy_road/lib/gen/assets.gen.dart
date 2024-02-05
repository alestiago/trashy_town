/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/barrel.png
  AssetGenImage get barrel => const AssetGenImage('assets/images/barrel.png');

  /// File path: assets/images/grass.png
  AssetGenImage get grass => const AssetGenImage('assets/images/grass.png');

  /// File path: assets/images/road.png
  AssetGenImage get road => const AssetGenImage('assets/images/road.png');

  /// File path: assets/images/trash.png
  AssetGenImage get trash => const AssetGenImage('assets/images/trash.png');

  /// File path: assets/images/trash_can.png
  AssetGenImage get trashCan =>
      const AssetGenImage('assets/images/trash_can.png');

  /// List of all assets
  List<AssetGenImage> get values => [barrel, grass, road, trash, trashCan];
}

class $AssetsTilesGen {
  const $AssetsTilesGen();

  /// File path: assets/tiles/Tiles.tsx
  String get tiles => 'assets/tiles/Tiles.tsx';

  /// File path: assets/tiles/barrel.tx
  String get barrel => 'assets/tiles/barrel.tx';

  /// File path: assets/tiles/finish.tx
  String get finish => 'assets/tiles/finish.tx';

  /// File path: assets/tiles/map.tmx
  String get map => 'assets/tiles/map.tmx';

  /// File path: assets/tiles/spawn.tx
  String get spawn => 'assets/tiles/spawn.tx';

  /// File path: assets/tiles/trash.tx
  String get trash => 'assets/tiles/trash.tx';

  /// List of all assets
  List<String> get values => [tiles, barrel, finish, map, spawn, trash];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsTilesGen tiles = $AssetsTilesGen();
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
