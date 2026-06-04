import 'package:flutter/material.dart';
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/core/services/tracking_service.dart';
import 'package:provider/provider.dart';
import 'package:irisense/features/settings/view_models/settings_viewmodel.dart';
import 'package:irisense/l10n/app_localizations.dart';

class CalibrationButton extends StatefulWidget {
  final SettingsViewModel viewmodel;
  const CalibrationButton({
    super.key,
    required this.viewmodel
  });

  @override
  State<CalibrationButton> createState() => _CalibrationButtonState();
}

class _CalibrationButtonState extends State<CalibrationButton> {
  int currentIndex = 0;
  late TrackingService trackingService;

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0: return Icons.play_arrow_rounded;
      case 1: return Icons.arrow_forward_ios_rounded;
      case 2: return Icons.arrow_forward_ios_rounded;
      case 3: return Icons.stop_rounded;
      default: return Icons.play_arrow_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    trackingService = Provider.of<TrackingService>(context);

    final List<String> calibrationBtnSteps = [
      AppLocalizations.of(context)!.calibrationBtn0,
      AppLocalizations.of(context)!.calibrationBtn1,
      AppLocalizations.of(context)!.calibrationBtn2,
      AppLocalizations.of(context)!.calibrationBtn3
    ];

    void _handleTap() {
      setState(() {
        if (currentIndex == calibrationBtnSteps.length - 1) {
          currentIndex = 0;
        } else {
          currentIndex++;
        }
      });
      widget.viewmodel.calibrateBtn_onTap();
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () =>  _handleTap(),
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.white.withOpacity(0.1),
        child: Ink(
          width: 220, 
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.darkInput,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  _getIconForIndex(currentIndex),
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    calibrationBtnSteps[currentIndex],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
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