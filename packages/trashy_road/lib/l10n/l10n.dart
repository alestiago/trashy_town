import 'package:flutter/widgets.dart';
import 'package:trashy_road/l10n/l10n.dart';

export 'package:trashy_road/l10n/arb/app_localizations.dart';

/// Extension for [AppLocalizations] to access it from [BuildContext].
///
/// If the [AppLocalizations] is not found, generate it using:
/// ```sh
/// # Generate new AppLocalizations (from packages/trashy_road):
/// flutter gen-l10n
/// ```
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
