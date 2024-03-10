import 'package:basura/basura.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/loading/loading.dart';
import 'package:trashy_road/src/play/play.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future<void> _onPreloadComplete(BuildContext context) async {
    final navigator = Navigator.of(context);
    await Future<void>.delayed(AnimatedProgressBar.intrinsicAnimationDuration);
    if (!mounted) {
      return;
    }
    await navigator.pushReplacement<void, void>(PlayPage.route());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PreloadCubit, PreloadState>(
      listenWhen: (prevState, state) =>
          !prevState.isComplete && state.isComplete,
      listener: (context, state) => _onPreloadComplete(context),
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff5F97C4),
              Color(0xff64A5CC),
            ],
          ),
        ),
        child: Center(
          child: _LoadingInternal(),
        ),
      ),
    );
  }
}

class _LoadingInternal extends StatelessWidget {
  const _LoadingInternal();

  @override
  Widget build(BuildContext context) {
    final basuraTheme = BasuraTheme.of(context);
    final textStyle = basuraTheme.textTheme.button;

    return BlocBuilder<PreloadCubit, PreloadState>(
      builder: (context, state) {
        final loadingMessage = 'Loading ${state.currentLabel}';

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: AnimatedProgressBar(
                progress: state.progress,
                backgroundColor: BasuraColors.white,
                foregroundColor: BasuraColors.black,
              ),
            ),
            DefaultTextStyle(
              style: textStyle,
              child: Text(
                loadingMessage,
                style: textStyle.copyWith(fontSize: 24),
              ),
            ),
          ],
        );
      },
    );
  }
}
