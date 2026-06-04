import 'package:flutter/material.dart';
import 'dart:async';
// Core
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/l10n/app_localizations.dart';
// Settings
import '../view_models/settings_viewmodel.dart';

class GazeInputLog extends StatefulWidget {
  final SettingsViewModel viewmodel;
  const GazeInputLog({super.key, required this.viewmodel});

  @override
  State<GazeInputLog> createState() => _GazeInputLogState();
}

class _GazeInputLogState extends State<GazeInputLog> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.viewmodel.insertItemStream.listen((index) {
      _listKey.currentState?.insertItem(index);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

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
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // --- Topbar ---
        Container(
          width: (screenWidth * 0.22).roundToDouble(),
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.infoHeader,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
          ),
          child: Center(
            child: Text(AppLocalizations.of(context)!.inputLog, style: AppTextStyles.interBold18),
          ),
        ),
        // --- Topbar ---

        // --- Content ---
        Container(
          width: (screenWidth * 0.22).roundToDouble(),
          height: 168,
          decoration: BoxDecoration(
            color: AppColors.infoSurface,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(18.0),
              bottomRight: Radius.circular(18.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
            child: AnimatedList(
              key: _listKey,
              physics: const NeverScrollableScrollPhysics(),
              initialItemCount: widget.viewmodel.inputLog_items.length,
              itemBuilder: (context, index, animation) {
                bool isTop = index == 0;
                
                return SizeTransition(
                  sizeFactor: animation,
                  child: Align(
                    alignment: Alignment.center,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: isTop ? 1.0 : 0.6,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 400),
                        style: isTop
                            ? AppTextStyles.interBold18
                            : AppTextStyles.interMedium14,
                        child: Text(_translateInput(widget.viewmodel.inputLog_items[index], context)), 
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // --- Content ---
      ],
    );
  }
}