import 'package:basura/basura.dart';
import 'package:flutter/material.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/maps/maps.dart';

class PlayPage extends StatelessWidget {
  const PlayPage({super.key});

  /// The identifier for the route.
  static String identifier = 'play';

  static Route<void> route() {
    return BasuraBlackEaseInOut<void>(
      settings: RouteSettings(name: identifier),
      builder: (_) => const PlayPage(),
    );
  }

  Future<void> _onPlay(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator.push(MapsMenuPage.route());
  }

  @override
  Widget build(BuildContext context) {
    final theme = BasuraTheme.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            // TODO(alestiago): Use background render when available.
            Assets.images.grass.path,
            repeat: ImageRepeat.repeat,
          ),
        ),
        Align(
          child: SizedBox(
            width: 200,
            height: 100,
            child: DefaultTextStyle(
              style: theme.textTheme.button,
              child: BasuraGlossyTextButton(
                onPressed: () => _onPlay(context),
                label: 'Play',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
