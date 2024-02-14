import 'package:flame/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/loading/cubit/cubit.dart';
import 'package:trashy_road/src/loading/view/loading_page.dart';
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
            images: Images(prefix: ''),
            tiled: TiledCache(),
          )..loadSequentially(),
        ),
        BlocProvider(
          create: (context) => GameMapsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoadingPage(),
      ),
    );
  }
}
