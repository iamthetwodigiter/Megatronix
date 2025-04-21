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
}
