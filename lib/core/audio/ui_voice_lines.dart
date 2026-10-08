import '../../l10n/generated/app_localizations.dart';
import '../content/localized_text.dart';

/// A voice line for app chrome text, resolved through ARB.
/// [text] receives AppLocalizations of the requested [AppLanguage].
class UiVoiceLine {
  const UiVoiceLine(this.key, this.text);

  final String key;
  final String Function(AppLocalizations l, AppLanguage lang) text;
}

const coreUiVoiceLines = <UiVoiceLine>[
  UiVoiceLine('common.success', _success),
  UiVoiceLine('common.almost', _almost),
];

String _success(AppLocalizations l, AppLanguage lang) =>
    '${l.feedbackSuccessTitle} ${l.feedbackSuccessBody}';

String _almost(AppLocalizations l, AppLanguage lang) =>
    '${l.feedbackAlmostTitle} ${l.feedbackAlmostBody}';
