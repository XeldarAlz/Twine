import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:twine/core/services/haptic_service.dart';
import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/theme/twine_typography.dart';

/// 6-digit OTP input with individual fields and auto-advance.
class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    required this.onCompleted,
    this.hasError = false,
  });

  final ValueChanged<String> onCompleted;
  final bool hasError;

  @override
  State<OtpInput> createState() => OtpInputState();
}

class OtpInputState extends State<OtpInput> with SingleTickerProviderStateMixin {
  static const _length = 6;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_length, (_) => TextEditingController());
    _focusNodes = List.generate(_length, (_) => FocusNode());

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(OtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) {
      _shake();
    }
  }

  void _shake() {
    _shakeController.forward(from: 0);
    TwineHaptics.error();
  }

  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      // Handle paste
      final pasted = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (pasted.length >= _length) {
        for (int i = 0; i < _length; i++) {
          _controllers[i].text = pasted[i];
        }
        _focusNodes.last.requestFocus();
        widget.onCompleted(pasted.substring(0, _length));
        return;
      }
      // Just take the last typed digit
      _controllers[index].text = value[value.length - 1];
    }

    TwineHaptics.light();

    if (value.isNotEmpty && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    final code = _code;
    if (code.length == _length) {
      widget.onCompleted(code);
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final shake =
            _shakeController.isAnimating ? _shakeAnimation.value * 10 : 0.0;
        final offset = shake *
            ((_shakeAnimation.value * 6.28).remainder(6.28) < 3.14 ? 1 : -1);
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_length, (index) {
          return Container(
            width: 48,
            height: 56,
            margin: EdgeInsets.only(
              left: index == 0 ? 0 : TwineSpacing.sm,
            ),
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) => _onKeyEvent(index, event),
              child: TextFormField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 2, // Allow 2 to detect paste
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TwineTypography.headingLg.copyWith(
                  color: widget.hasError
                      ? TwineColors.error
                      : Theme.of(context).colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: TwineSpacing.md,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.hasError
                          ? TwineColors.error
                          : TwineColors.silver,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.hasError
                          ? TwineColors.error
                          : TwineColors.twineRose,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) => _onChanged(index, value),
              ),
            ),
          );
        }),
      ),
    );
  }
}
