import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/generated/app_localizations.dart';
import '../audio/voice_service.dart';
import '../sim_api/dashed_border.dart';
import '../theme/app_tokens.dart';

/// «Озвучить» / «Остановить» / «Озвучка недоступна» for one voice key.
/// Needs a [VoiceService] above it (see AppScope). While playing, the icon
/// pulses for a few cycles only, and not at all when animations are disabled.
class VoiceButton extends StatefulWidget {
  const VoiceButton({super.key, required this.audioKey});

  final String audioKey;

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton>
    with SingleTickerProviderStateMixin {
  static const _pulseCycles = 3;

  AnimationController? _pulse;
  bool _pulsing = false;

  void _syncPulse(bool playing, bool animate) {
    final want = playing && animate;
    if (want == _pulsing) return;
    _pulsing = want;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_pulsing) {
        final c = _pulse ??= AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 600),
        );
        c.repeat(reverse: true, count: _pulseCycles * 2);
      } else {
        _pulse?.stop();
        _pulse?.value = 0;
      }
    });
  }

  @override
  void dispose() {
    _pulse?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final voice = context.watch<VoiceService>();
    final state = voice.stateOf(widget.audioKey);
    _syncPulse(
      state == VoiceState.playing,
      !MediaQuery.disableAnimationsOf(context),
    );
    final t = context.tokens;

    if (state == VoiceState.unavailable) {
      return Semantics(
        button: true,
        enabled: false,
        label: l.voiceUnavailable,
        excludeSemantics: true,
        child: DashedBorder(
          color: t.disabledFg,
          radius: AppSizes.buttonRadius,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.tapMain),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s16,
                vertical: AppSizes.s8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.volume_off,
                    size: AppSizes.iconInButton,
                    color: t.disabledFg,
                  ),
                  const SizedBox(width: AppSizes.s8),
                  Flexible(
                    child: Text(
                      l.voiceUnavailable,
                      style: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(color: t.disabledFg),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final playing = state == VoiceState.playing;
    final icon = Icon(playing ? Icons.stop : Icons.volume_up);
    final pulse = _pulse;
    final animatedIcon = (playing && pulse != null)
        ? ScaleTransition(
            scale: Tween<double>(begin: 1, end: 1.2).animate(pulse),
            child: icon,
          )
        : icon;
    final label = Text(playing ? l.voiceStop : l.voicePlay);
    void onPressed() => voice.toggle(widget.audioKey);
    return playing
        ? FilledButton.icon(
            onPressed: onPressed,
            icon: animatedIcon,
            label: label,
          )
        : OutlinedButton.icon(onPressed: onPressed, icon: icon, label: label);
  }
}
