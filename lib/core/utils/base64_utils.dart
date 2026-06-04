import 'dart:convert';
import 'dart:typed_data';

class Base64Utils {
  static Uint8List decodeImage(String base64String) {
    return base64Decode(base64String);
  }
}

// Example: Image.memory(Base64Utils.decodeImage(base64String))