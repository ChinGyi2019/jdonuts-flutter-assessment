import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/session.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../viewmodels/language_preference.dart';
import '../widgets/settings_profile_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _loggingOut = false;
  bool _savingLanguage = false;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final isMyanmar = Localizations.localeOf(context).languageCode == 'my';
    return Scaffold(
      backgroundColor: AppColors.catalogBackground,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding + 24),
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    strings.settings,
                    style: const TextStyle(
                      color: AppColors.catalogText,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const SettingsProfileCard(),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            strings.language +
                                (isMyanmar ? ' (မြန်မာ)' : ' (English)'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: _LanguageToggle(
                              selected:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'my'
                                  ? 'my'
                                  : 'en',
                              enabled:
                                  !_savingLanguage &&
                                  !ref
                                      .watch(languagePreferenceProvider)
                                      .isLoading,
                              onChanged: _setLanguage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.catalogPink,
                    foregroundColor: AppColors.catalogText,
                    disabledBackgroundColor: AppColors.welcomeBackground,
                    disabledForegroundColor: AppColors.catalogText,
                    minimumSize: const Size.fromHeight(52),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onPressed: _loggingOut ? null : _logOut,
                  icon: _loggingOut
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            color: AppColors.catalogText,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          LucideIcons.logOut,
                          size: 19,
                          color: AppColors.white,
                        ),
                  label: Text(
                    _loggingOut ? strings.loggingOut : strings.logout,
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setLanguage(String code) async {
    setState(() => _savingLanguage = true);
    final saved = await ref
        .read(languagePreferenceProvider.notifier)
        .setLanguage(code);
    if (!mounted) return;
    setState(() => _savingLanguage = false);
    if (!saved) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.languageSaveError),
          ),
        );
    }
  }

  Future<void> _logOut() async {
    if (_loggingOut) return;
    final strings = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.white,
        scrollable: true,
        title: Text(strings.logoutConfirmationTitle),
        content: Text(strings.logoutConfirmationMessage),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              foregroundColor: AppColors.catalogText,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(strings.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.catalogPink,
              foregroundColor: AppColors.catalogText,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              strings.logout,
              style: const TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true || _loggingOut) return;

    setState(() => _loggingOut = true);
    try {
      await ref.read(sessionProvider.notifier).signOut();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.logoutError)),
        );
    } finally {
      if (mounted) setState(() => _loggingOut = false);
    }
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  final String selected;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isMyanmar = selected == 'my';
    void select(String code) {
      if (enabled && code != selected) onChanged(code);
    }

    return Semantics(
      label: AppLocalizations.of(context)!.language,
      value: isMyanmar ? 'မြန်မာ' : 'English',
      toggled: isMyanmar,
      enabled: enabled,
      onTap: enabled ? () => select(isMyanmar ? 'en' : 'my') : null,
      child: ExcludeSemantics(
        child: GestureDetector(
          key: const ValueKey('language_toggle'),
          onTap: enabled ? () => select(isMyanmar ? 'en' : 'my') : null,
          onHorizontalDragEnd: enabled
              ? (details) {
                  final velocity = details.primaryVelocity ?? 0;
                  if (velocity > 0) select('my');
                  if (velocity < 0) select('en');
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: isMyanmar
                  ? AppColors.catalogPink.withValues(alpha: 0.2)
                  : AppColors.authBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  alignment: isMyanmar
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: SizedBox(
                    width: 56,
                    height: 40,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            isMyanmar ? '🇲🇲' : '🇬🇧',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  alignment: isMyanmar
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
