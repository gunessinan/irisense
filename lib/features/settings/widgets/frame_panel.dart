import 'package:flutter/material.dart';
// Core
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/core/services/tracking_service.dart';
import 'package:irisense/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../view_models/settings_viewmodel.dart';
import '../widgets/calibration_btn.dart';

class FramePanel extends StatefulWidget {
  final SettingsViewModel viewmodel;
  const FramePanel({
    super.key,
    required this.viewmodel
  });

  @override
  State<FramePanel> createState() => _FramePanelState();
}

class _FramePanelState extends State<FramePanel> {
  String _translateInput(String input, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (input) {
      case "Straight": return l10n.straight;
      case "Blink": return l10n.closed;
      case "Left Up": return l10n.leftUp;
      case "Up": return l10n.up;
      case "Right Up": return l10n.rightUp;
      case "Left": return l10n.leftDown;
      case "Down": return l10n.down;
      case "Right": return l10n.rightDown;
      default: return input;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    final trackingService = Provider.of<TrackingService>(context);
    
    // Take image data
    final imageBytes = trackingService.gazeData.image;

    return Column(
      children: [
        // --- Eye Frame ---
        Container(
          width: (screen_width * 0.78).roundToDouble(),
          height: 145,
          decoration: BoxDecoration(
            color: AppColors.infoSurface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0)
            )
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0)
            ),
            child: imageBytes != null
                ? Image.memory(
                    imageBytes,
                    gaplessPlayback: true, 
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Center(
                    child: Text(AppLocalizations.of(context)!.eyeFrame, style: AppTextStyles.interBold18),
                  ),
          ),
        ),
        // --- Eye Frame ---

        // --- Frame Information ---
        Container(
          width: (screen_width * 0.78).roundToDouble(),
          height: 55,
          decoration: BoxDecoration(
            color: AppColors.darkElevated,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(18.0),
              bottomRight: Radius.circular(18.0)
            )
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Info Column #1 ---
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.eyePos,
                    style: AppTextStyles.interMedium14,
                  ),
                  Text(
                    "${trackingService.gazeData.corX.toInt()}, ${trackingService.gazeData.corY.toInt()}",
                    style: AppTextStyles.interMedium14,
                  )
                ],
              ),
              // --- Info Column #1 ---

              // --- Info Column #2 ---
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.eyeReg,
                    style: AppTextStyles.interMedium14,
                  ),
                  Text(
                    _translateInput(trackingService.gazeData.gazeType, context), 
                    style: AppTextStyles.interMedium14,
                  )
                ],
              ),
              // --- Info Column #2 ---

              // --- Calibration Button ---
              CalibrationButton(viewmodel: widget.viewmodel)
              // --- Calibration Button ---
            ],
          ),
        ),
        // --- Frame Information ---
      ],
    );
  }
}