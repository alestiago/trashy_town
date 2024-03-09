import 'package:basura/basura.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    final size = MediaQuery.sizeOf(context);

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff5F97C4),
            Color(0xff64A5CC),
          ],
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.85),
            child: SizedBox.square(
              dimension: size.shortestSide / 1.6,
              child: AspectRatio(
                aspectRatio: 776 / 458,
                child: Image.asset(
                  Assets.images.display.logo.path,
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: null,
            child: Transform.translate(
              offset: Offset(
                0,
                size.width > size.height
                    ? (size.width - size.height) / ((1920 / 732) * 2)
                    : 0,
              ),
              child: Image.asset(
                Assets.images.display.playBackgroundHouses.path,
                fit: BoxFit.cover,
              ),
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
      ),
    );
  }
}
