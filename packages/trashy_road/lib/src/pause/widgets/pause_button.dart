import 'package:basura/basura.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/pause/pause.dart';

/// A button that can be used to pause.
class PauseButton extends StatelessWidget {
  const PauseButton({
    required this.onPause,
    required this.onResume,
    required this.onReplay,
    super.key,
  });

  /// A callback that is called when the button is pressed.
  ///
  /// If it returns `true`, the [PausePage] will be pushed.
  final bool Function() onPause;

  /// {@macro PausePage.onResume}
  final bool Function() onResume;

  /// {@macro PausePage.onReplay}
  final bool Function() onReplay;

  void _onPause(BuildContext context) {
    if (onPause()) {
      Navigator.of(context).push(
        PausePage.route(
          onResume: onResume,
          onReplay: onReplay,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ImageBuilder(
      provider: Assets.images.paperBackgroundSquare.provider(),
      builder: (paperBackground) {
        return _ImageBuilder(
          provider: Assets.images.pauseIcon.provider(),
          builder: (pauseIcon) {
            return DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: paperBackground,
                  fit: BoxFit.fill,
                ),
              ),
              child: AnimatedHoverBrightness(
                child: GestureDetector(
                  onTap: () => _onPause(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Image(image: pauseIcon, width: 50, height: 50),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ImageBuilder extends StatefulWidget {
  const _ImageBuilder({
    required this.provider,
    required this.builder,
  });

  final ImageProvider provider;

  final Widget Function(ImageProvider provider) builder;

  @override
  State<_ImageBuilder> createState() => __ImageBuilderState();
}

class __ImageBuilderState extends State<_ImageBuilder> {
  late final _image = widget.provider;

  late final Future<void> _cacheImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cacheImage = precacheImage(_image, context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cacheImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        return widget.builder(_image);
      },
    );
  }
}
