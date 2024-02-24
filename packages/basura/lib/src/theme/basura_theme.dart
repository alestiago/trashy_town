import 'package:basura/basura.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// {@template BasuraTheme}
/// An [InheritedWidget] that provides the [BasuraThemeData] to its descendants.
/// {@endtemplate}
class BasuraTheme extends InheritedWidget {
  /// {@macro BasuraTheme}
  BasuraTheme({
    required this.data,
    required Widget child,
    super.key,
  }) : super(
          child: _BasuraTheme(data: data, child: child),
        );

  /// {@macro BasuraThemeData}
  final BasuraThemeData data;

  /// The [BasuraThemeData] from the closest [BasuraTheme] instance that
  /// encloses the given context.
  static BasuraThemeData of(BuildContext context) {
    final basuraTheme =
        context.dependOnInheritedWidgetOfExactType<BasuraTheme>();
    return basuraTheme?.data ?? BasuraThemeData.light();
  }

  @override
  bool updateShouldNotify(covariant BasuraTheme oldWidget) {
    return data != oldWidget.data;
  }
}

class _BasuraTheme extends StatelessWidget {
  const _BasuraTheme({
    required this.data,
    required this.child,
  });

  final BasuraThemeData data;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: data.textTheme.button,
      child: child,
    );
  }
}

/// {@template BasuraThemeData}
/// The theme for the Basura design system.
/// {@endtemplate}
class BasuraThemeData extends Equatable {
  /// {@macro BasuraThemeData}
  const BasuraThemeData({
    required this.textTheme,
  });

  /// A light theme for the Basura design system.
  factory BasuraThemeData.light() {
    final textTheme = BasuraTextThemeData(
      button: TextStyle(
        fontFamily: BasuraFontFamily.lilitaOne.name,
        fontSize: 50,
        package: Basura.packageName,
        color: BasuraColors.white,
        shadows: const [
          Shadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            color: BasuraColors.deepGreen,
          ),
        ],
      ),
    );

    return BasuraThemeData(
      textTheme: textTheme,
    );
  }

  /// {@macro BasuraTextThemeData}
  final BasuraTextThemeData textTheme;

  @override
  List<Object?> get props => [textTheme];
}
