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
  lilitaOne._(name: 'LilitaOne'),

  /// The Caveat font family.
  ///
  /// See also:
  ///
  /// * [Caveat Google Fonts](https://fonts.google.com/specimen/Caveat)
  caveat._(name: 'Caveat');

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
    required this.cardHeading,
    required this.cardSubheading,
  });

  /// Light [BasuraTextThemeData] for the Basura design system.
  factory BasuraTextThemeData.light() {
    return BasuraTextThemeData(
      button: TextStyle(
        fontFamily: BasuraFontFamily.lilitaOne.name,
        fontSize: 80,
        package: Basura.packageName,
        color: BasuraColors.white,
      ),
      cardHeading: TextStyle(
        fontFamily: BasuraFontFamily.caveat.name,
        fontSize: 80,
        fontWeight: FontWeight.bold,
        letterSpacing: 10,
        package: Basura.packageName,
        color: BasuraColors.black,
      ),
      cardSubheading: TextStyle(
        fontFamily: BasuraFontFamily.caveat.name,
        fontSize: 25,
        fontWeight: FontWeight.bold,
        letterSpacing: 10,
        package: Basura.packageName,
        color: BasuraColors.black,
      ),
    );
  }

  /// A text style for buttons.
  final TextStyle button;

  /// A text style for card headings.
  final TextStyle cardHeading;

  /// A text style for card subheadings.
  final TextStyle cardSubheading;

  @override
  List<Object?> get props => [
        button,
        cardHeading,
        cardSubheading,
      ];
}
