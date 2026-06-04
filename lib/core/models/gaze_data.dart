import 'package:flutter/services.dart';

class GazeData {
  String gazeType;
  double corX;
  double corY;
  Uint8List? image;

  GazeData({
    required this.gazeType,
    required this.corX,
    required this.corY,
    required this.image
  });

  String cor()
  {
    return "${corX}, ${corY}";
  }
}