import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_theme.dart';

class AuthProgress extends StatelessWidget {
  const AuthProgress({
    required this.step,
    this.birthDateSelected = false,
    super.key,
  });
  final int step;
  final bool birthDateSelected;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(end: step == 4 && !birthDateSelected ? .9 : step / 4),
    duration: AppMotion.duration(context, AppMotion.entrance),
    curve: AppMotion.curve,
    builder: (context, value, _) => SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 7,
              backgroundColor: AppColors.authBlueLight,
              color: AppColors.authPink,
              strokeCap: StrokeCap.butt,
            ),
          ),
          AnimatedScale(
            scale: step == 4 && birthDateSelected ? 1 : 0,
            duration: AppMotion.duration(context, AppMotion.standard),
            child: const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.authPink,
              child: Icon(LucideIcons.check, size: 16, color: AppColors.white),
            ),
          ),
        ],
      ),
    ),
  );
}

class AuthPrimaryButton extends StatefulWidget {
  const AuthPrimaryButton({
    required this.label,
    required this.loading,
    required this.onPressed,
    this.height = 52,
    this.fontSize = 13,
    super.key,
  });
  final String label;
  final bool loading;
  final VoidCallback? onPressed;
  final double height;
  final double fontSize;
  @override
  State<AuthPrimaryButton> createState() => _AuthPrimaryButtonState();
}

class _AuthPrimaryButtonState extends State<AuthPrimaryButton> {
  bool down = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: widget.onPressed == null
        ? null
        : (_) => setState(() => down = true),
    onTapUp: (_) => setState(() => down = false),
    onTapCancel: () => setState(() => down = false),
    child: AnimatedScale(
      scale: down ? .97 : 1,
      duration: AppMotion.duration(context, AppMotion.press),
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.authBlue,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.authBlue.withValues(alpha: .45),
            disabledForegroundColor: AppColors.white,
            shape: const StadiumBorder(),
            textStyle: TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
              fontSize: widget.fontSize,
            ),
          ),
          onPressed: widget.loading ? null : widget.onPressed,
          child: AnimatedSwitcher(
            duration: AppMotion.duration(context, AppMotion.standard),
            child: widget.loading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : Text(widget.label, key: const ValueKey('label')),
          ),
        ),
      ),
    ),
  );
}

class AuthEntrance extends StatelessWidget {
  const AuthEntrance({required this.child, required this.order, super.key});
  final Widget child;
  final int order;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: AppMotion.duration(
      context,
      AppMotion.entrance + AppMotion.stagger * order,
    ),
    curve: Curves.easeOutCubic,
    builder: (context, value, child) => Opacity(
      opacity: value,
      child: Transform.translate(
        offset: Offset(0, 18 * (1 - value)),
        child: child,
      ),
    ),
    child: child,
  );
}
