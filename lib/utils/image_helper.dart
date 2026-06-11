import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static Future<String?> pickAndCompressImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (image != null) {
        File imageFile = File(image.path);
        List<int> imageBytes = await imageFile.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        return base64Image;
      }
    } catch (e) {
      // Silent fail
    }
    return null;
  }

  static Widget imageFromBase64(String base64String,
      {double? width, double? height}) {
    if (base64String.isEmpty) {
      return const Icon(Icons.image_not_supported,
          size: 50, color: Colors.grey);
    }
    try {
      return Image.memory(
        base64Decode(base64String),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
        },
      );
    } catch (e) {
      return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
    }
  }
}
