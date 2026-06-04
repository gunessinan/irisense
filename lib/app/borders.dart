import 'package:flutter/material.dart';
import 'package:irisense/l10n/app_localizations.dart';

class Borders extends StatelessWidget {
  const Borders({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double opacity = 0.15;

    Widget div(double w, double h, String text)
    {
      return Container(
        width: screenWidth * w,
        height: screenHeight * h,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(opacity),
          border: Border.all(color: Colors.blueGrey.withOpacity(opacity), width: 2, style: BorderStyle.solid)
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(opacity),
              fontSize: 24.0,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      );
    }

    return IgnorePointer(
      child: Container(
        color: Colors.black45.withOpacity(opacity),
        width: screenWidth,
        height: screenHeight,
        child: Row(
          children: [
            // <--- Left Column --->
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                div(0.3, 0.44, AppLocalizations.of(context)!.leftUp),
                div(0.3, 0.12, AppLocalizations.of(context)!.straight),
                div(0.3, 0.44, AppLocalizations.of(context)!.leftDown),
              ],
            ),
            // <--- Center Column --->
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                div(0.4, 0.15, AppLocalizations.of(context)!.up),
                div(0.4, 0.7, AppLocalizations.of(context)!.straight),
                div(0.4, 0.15, AppLocalizations.of(context)!.down),
              ],
            ),
            // <--- Right Column --->
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                div(0.3, 0.44, AppLocalizations.of(context)!.rightUp),
                div(0.3, 0.12, AppLocalizations.of(context)!.straight),
                div(0.3, 0.44, AppLocalizations.of(context)!.rightDown),
              ],
            ),
          ],
        ),
      ),
    ); 
  }
}