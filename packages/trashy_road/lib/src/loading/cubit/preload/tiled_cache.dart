import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

abstract class TiledCacheException implements Exception {
  TiledCacheException({required this.message});

  final String message;

  @override
  String toString() => message;
}

class TiledCacheMapLoadingException extends TiledCacheException {
  TiledCacheMapLoadingException({
    required String path,
    required Object error,
  }) : super(message: 'Failed to load $TiledMap at path: $path. Got: $error');
}

class TiledCacheMapParsingException extends TiledCacheException {
  TiledCacheMapParsingException._({
    required String path,
    required Object error,
  }) : super(message: 'Failed to parse $TiledMap at path: $path. Got: $error');
}

class TiledCache {
  TiledCache({
    AssetBundle? bundle,
  }) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  final Map<String, TiledMap> _cache = {};

  TiledMap fromCache(String path) {
    final map = _cache[path];
    assert(
      map != null,
      'Tried to access a $TiledMap "$map" that does not exist in the cache. '
      'Make sure to load() a $TiledMap before accessing it',
    );

    return _cache[path]!;
  }

  Future<void> load(String path) async {
    if (_cache.containsKey(path)) {
      return;
    }

    late String content;
    try {
      content = await _bundle.loadString(path);
    } catch (e, stackTrace) {
      final error = TiledCacheMapLoadingException(
        path: path,
        error: e,
      );
      throw Error.throwWithStackTrace(error, stackTrace);
    }

    late TiledMap map;
    try {
      map = await TiledMap.fromString(content, (key) {
        return FlameTsxProvider.parse(key, _bundle);
      });
    } catch (e, stackTrace) {
      final error = TiledCacheMapParsingException._(path: path, error: e);
      throw Error.throwWithStackTrace(error, stackTrace);
    }

    _cache[path] = map;
  }

  Future<void> loadAll(List<String> paths) async {
    await Future.wait([
      for (final path in paths) load(path),
    ]);
  }
}
