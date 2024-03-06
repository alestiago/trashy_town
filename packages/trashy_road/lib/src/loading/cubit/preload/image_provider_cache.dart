import 'package:flutter/material.dart';
import 'package:trashy_road/gen/gen.dart';

abstract class _ImageProviderCacheException implements Exception {
  _ImageProviderCacheException({required this.message});

  final String message;

  @override
  String toString() => message;
}

class ImageProviderPreCacheException extends _ImageProviderCacheException {
  ImageProviderPreCacheException._({
    required String path,
    required Object error,
  }) : super(
          message: 'Failed to parse $ImageProvider at path: $path. Got: $error',
        );
}

class ImageProviderCache {
  ImageProviderCache({required this.precacheImage});

  final Future<void> Function(ImageProvider<Object> provider) precacheImage;

  final Map<String, ImageProvider> _cache = {};

  ImageProvider fromCache(String path) {
    final provider = _cache[path];
    assert(
      provider != null,
      '''Tried to access an $ImageProvider "$provider" that does not exist in the cache. '''
      'Make sure to load() an $ImageProvider before accessing it',
    );

    return _cache[path]!;
  }

  Future<void> load(AssetGenImage image) async {
    final path = image.path;
    if (_cache.containsKey(path)) {
      return;
    }

    late ImageProvider provider;
    try {
      provider = image.provider();
      await precacheImage(provider);
    } catch (e, stackTrace) {
      final error = ImageProviderPreCacheException._(path: path, error: e);
      throw Error.throwWithStackTrace(error, stackTrace);
    }

    _cache[path] = provider;
  }

  Future<void> loadAll(List<AssetGenImage> paths) async {
    await Future.wait([
      for (final path in paths) load(path),
    ]);
  }
}
