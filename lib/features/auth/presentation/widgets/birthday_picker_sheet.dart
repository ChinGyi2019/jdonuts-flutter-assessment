import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import 'auth_visuals.dart';

Future<DateTime?> showBirthdayPicker(BuildContext context, {DateTime? date}) {
  const defaultAge = 25;
  final today = DateUtils.dateOnly(DateTime.now());
  final defaultYear = today.year - defaultAge;
  final defaultDay = today.day.clamp(
    1,
    DateUtils.getDaysInMonth(defaultYear, today.month),
  );
  final initialDate = date ?? DateTime(defaultYear, today.month, defaultDay);

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.white,
    barrierColor: Colors.black54,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    constraints: const BoxConstraints(maxWidth: 520),
    sheetAnimationStyle: MediaQuery.disableAnimationsOf(context)
        ? AnimationStyle.noAnimation
        : null,
    builder: (context) => _BirthdayPickerSheet(
      initialDate: initialDate.isAfter(today) ? today : initialDate,
      latestDate: today,
    ),
  );
}

class _BirthdayPickerSheet extends StatefulWidget {
  const _BirthdayPickerSheet({
    required this.initialDate,
    required this.latestDate,
  });

  final DateTime initialDate;
  final DateTime latestDate;

  @override
  State<_BirthdayPickerSheet> createState() => _BirthdayPickerSheetState();
}

class _BirthdayPickerSheetState extends State<_BirthdayPickerSheet> {
  static const _itemExtent = 36.0;
  late DateTime _selectedDate = widget.initialDate;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final sidePadding = MediaQuery.sizeOf(context).width < 360 ? 16.0 : 36.0;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 18),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(sidePadding, 8, sidePadding, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    strings.birthdayPickerTitle,
                    style: const TextStyle(
                      color: AppColors.authPink,
                      fontSize: 21,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  icon: const Icon(LucideIcons.x, color: AppColors.authText),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 144,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Container(
                      height: _itemExtent,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  CupertinoTheme(
                    data: const CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 20,
                          letterSpacing: -.5,
                          color: AppColors.authText,
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      dateOrder: DatePickerDateOrder.dmy,
                      initialDateTime: widget.initialDate,
                      minimumDate: DateTime(1),
                      maximumDate: widget.latestDate,
                      maximumYear: widget.latestDate.year,
                      itemExtent: _itemExtent,
                      selectionOverlayBuilder:
                          (_, {required selectedIndex, required columnCount}) =>
                              null,
                      onDateTimeChanged: (date) => _selectedDate = date,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AuthPrimaryButton(
              label: strings.birthdayPickerSelect,
              loading: false,
              height: 60,
              fontSize: 16,
              onPressed: () => Navigator.of(context).pop(_selectedDate),
            ),
          ],
        ),
      ),
    );
  }
}
