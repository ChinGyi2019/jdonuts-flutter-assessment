import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_theme.dart';

/// One editable value gives paste, autofill and backspace standard platform behavior.
/// Six visual cells represent its digits and advance as the value changes.
class OtpField extends StatelessWidget {
  const OtpField({
    required this.controller,
    required this.label,
    required this.enabled,
    required this.attempts,
    required this.error,
    required this.onChanged,
    super.key,
  });
  final TextEditingController controller;
  final String label;
  final bool enabled;
  final int attempts;
  final String? error;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder<double>(
          key: ValueKey(attempts),
          tween: Tween(begin: 0, end: 1),
          duration: AppMotion.duration(
            context,
            attempts == 0 ? Duration.zero : const Duration(milliseconds: 400),
          ),
          builder: (context, value, child) => Transform.translate(
            offset: Offset(math.sin(value * math.pi * 6) * (1 - value) * 10, 0),
            child: child,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IgnorePointer(
                child: Row(
                  spacing: AppSpacing.small,
                  children: List.generate(
                    6,
                    (index) => Expanded(
                      child: Container(
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: error == null
                                ? AppColors.white
                                : theme.colorScheme.error,
                          ),
                        ),
                        child: Text(
                          index < controller.text.length
                              ? controller.text[index]
                              : '',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // The input remains focusable and accessible while the cells show its value.
              Opacity(
                opacity: 0.01,
                child: TextField(
                  key: const ValueKey('otp-input'),
                  controller: controller,
                  enabled: enabled,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: InputDecoration(
                    labelText: label,
                    border: InputBorder.none,
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.small),
            child: Text(
              error!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
