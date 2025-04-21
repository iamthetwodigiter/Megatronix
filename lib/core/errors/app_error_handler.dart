import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/toast_widget.dart';
import 'package:toastification/toastification.dart';

class AppErrorHandler {
  static void handleError(
      BuildContext context, String title, String description,
      {ToastificationType type = ToastificationType.error}) {
    if (description.contains("Socket")) {
      title = "Network Error";
      description = "Please check your internet connection and try again.";
    } else if (description.contains('Invalid Token') ||
        description.contains('No token')) {
      title = "Session Expired";
      description = "Please login to continue.";
    } else if (description.contains("Timeout")) {
      title = "Timeout Error";
      description = "Request timed out. Please try again later.";
    } else if (description.contains("FormatException")) {
      title = "Format Error";
      description = "Invalid data format received.";
    } else if (description.contains("No Internet")) {
      title = "Network Error";
      description =
          "No internet connection. Please check your network settings.";
    } else if (description.contains("Unauthorized")) {
      title = "Unauthorized Access";
      description = "Unauthorized access. Please login again.";
    } else if (description.contains("Not Found")) {
      title = "Resource Not Found";
      description = "The requested resource could not be found.";
    } else if (description.contains("Internal Server Error")) {
      title = "Server Error";
      description = "An error occurred on the server. Please try again later.";
    } else if (description.contains("Bad Request")) {
      title = "Bad Request";
      description =
          "The request was invalid. Please check your input and try again.";
    }
    showToastification(
      context: context,
      title: title,
      description: description.replaceAll("Exception: ", ""),
      type: type,
    );
  }
}
