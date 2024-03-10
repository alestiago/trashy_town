import 'package:audioplayers/audioplayers.dart';
import 'package:basura/basura.dart';
import 'package:flame/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/audio/audio.dart';
import 'package:trashy_road/src/loading/loading.dart';
import 'package:trashy_road/src/maps/maps.dart';

void main() {
  runApp(const _MyApp());
}

class _MyApp extends StatelessWidget {
  const _MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PreloadCubit(
            audio: AudioCache(prefix: ''),
            images: Images(prefix: ''),
            tiled: TiledCache(),
            imageProviderCache: ImageProviderCache(
              precacheImage: (provider) => precacheImage(provider, context),
            ),
          )..loadSequentially(),
        ),
        BlocProvider(
          create: (context) => GameMapsBloc(),
        ),
        BlocProvider(
          create: (context) => AudioCubit(
            audioCache: context.read<PreloadCubit>().audio,
          ),
        ),
      ],
      child: BasuraTheme(
        data: BasuraThemeData.light(),
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const LoadingPage(),
        ),
      ),
    );
  }
}
