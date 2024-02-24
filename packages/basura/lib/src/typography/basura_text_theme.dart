import 'package:basura/basura.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Font families used by the Basura design system.
enum BasuraFontFamily {
  /// The Lilita One font family.
  ///
  /// See also:
  ///
  /// * [Lilita One Google Fonts](https://fonts.google.com/specimen/Lilita+One)
  lilitaOne._(name: 'LilitaOne');

  const BasuraFontFamily._({required this.name});

  /// The family name, as defined in the `pubspec.yaml`.
  final String name;
}

/// {@template BasuraTextThemeData}
/// The text theme for the Basura design system.
/// {@endtemplate}
class BasuraTextThemeData extends Equatable {
  /// {@macro BasuraTextThemeData}
  const BasuraTextThemeData({
    required this.button,
  });

  /// Light [BasuraTextThemeData] for the Basura design system.
  factory BasuraTextThemeData.light() {
    return BasuraTextThemeData(
      button: TextStyle(
        fontFamily: BasuraFontFamily.lilitaOne.name,
        fontSize: 100,
        package: Basura.packageName,
        color: BasuraColors.white,
      ),
    );
  }

  /// A text style for buttons.
  final TextStyle button;

  @override
  List<Object?> get props => [button];
}
