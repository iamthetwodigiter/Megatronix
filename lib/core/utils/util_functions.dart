import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UtilFunctions {
  static Future<XFile?> pickImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  static Future<List<XFile>?> pickMultipleImages() async {
    return await ImagePicker().pickMultiImage(limit: 10);
  }

  static String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy @HH:mm').format(parsedDate);
  }

  static List<String> getTextFieldImagesList(int count) {
    final List<String> allImages = [
      'assets/images/black-among-us.png',
      'assets/images/blue-among-us.png',
      'assets/images/green-among-us.png',
      'assets/images/light-blue-among-us.png',
      'assets/images/orange-among-us.png',
      'assets/images/red-among-us.png',
      'assets/images/rose-among-us.png',
      'assets/images/violet-among-us.png',
      'assets/images/white-among-us.png',
      'assets/images/yellow-among-us.png',
    ];
    final List<String> availableImages = List.from(allImages);
    final List<String> selectedImages = [];
    final numberOfImages = count.clamp(0, availableImages.length);
    for (int i = 0; i < numberOfImages; i++) {
      final index = Random().nextInt(availableImages.length);
      selectedImages.add(availableImages[index]);
      availableImages.removeAt(index);
    }
    return selectedImages;
  }

  static String getHeaderImage() {
    final List<String> allImages = [
      'assets/images/among-us.png',
      'assets/images/among-us (1).png',
      'assets/images/among-us (2).png',
      'assets/images/among-us (3).png',
      'assets/images/among-us (4).png',
      'assets/images/among-us (5).png',
      'assets/images/among-us (6).png',
      'assets/images/among-us (7).png',
      'assets/images/among-us (8).png',
      'assets/images/among-us (9).png',
    ];
    final index = Random().nextInt(allImages.length);
    return allImages.elementAt(index);
  }
}
