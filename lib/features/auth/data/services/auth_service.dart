import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:megatronix/config/config.dart';
import 'package:megatronix/common/services/secure_storage_service.dart';

class AuthService {
  static const String authBaseURL = "${Config.apiBaseURL}/auth";

  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<Map<String, dynamic>> registerUser(
      String name, String email, String password) async {
    final url = Uri.parse('$authBaseURL/register');
    final response = await http.post(
      url,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 201) {
      await _secureStorageService.writeToken(decodedBody['token']);
      return decodedBody['user'];
    } else if (response.statusCode == 400) {
      throw Exception(
          (decodedBody['validationErrors'] as Map<String, dynamic>)['message']);
    } else if (response.statusCode == 401) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden access. You do not have permission to perform this action.');
    } else if (response.statusCode == 429) {
      throw Exception(
          'Too Many Requests. Please wait before sending other one.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else if (response.statusCode == 503) {
      throw Exception(
          'Service Temporarily Unavailable due to overloading or maintenance of the server.');
    } else if (response.statusCode == 504) {
      throw Exception('Gateway Timeout Error.');
    } else {
      throw Exception(decodedBody['message']);
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$authBaseURL/login'),
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (decodedBody['token'] != null) {
        await _secureStorageService.writeToken(decodedBody['token']);
      }
      return decodedBody['user'];
    } else if (response.statusCode == 400) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 401) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden access. You do not have permission to perform this action.');
    } else if (response.statusCode == 429) {
      throw Exception(
          'Too Many Requests. Please wait before sending other one.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else if (response.statusCode == 503) {
      throw Exception(
          'Service Temporarily Unavailable due to overloading or maintenance of the server.');
    } else if (response.statusCode == 504) {
      throw Exception('Gateway Timeout Error.');
    } else if (response.statusCode >= 500) {
      throw Exception('Internal Server Error');
    }
    throw Exception(decodedBody['message']);
  }

  Future<Map<String, dynamic>> checkAuthStatus() async {
    final token = await _secureStorageService.readToken();

    if (token == null || token.isEmpty) {
      throw Exception('No token found. Please login again');
    }

    final response = await http.get(
      Uri.parse('$authBaseURL/check-token'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200 && decodedBody['valid'] == true) {
      return decodedBody['user'];
    } else if (response.statusCode == 400) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 401) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden access. You do not have permission to perform this action.');
    } else if (response.statusCode == 429) {
      throw Exception(
          'Too Many Requests. Please wait before sending other one.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else if (response.statusCode == 503) {
      throw Exception(
          'Service Temporarily Unavailable due to overloading or maintenance of the server.');
    } else if (response.statusCode == 504) {
      throw Exception('Gateway Timeout Error.');
    } else {
      String message = decodedBody['message'] ?? 'Invalid token';
      if (decodedBody['message'] == 'Error validating token') {
        message = 'Please login to continue';
      }
      await _secureStorageService.deleteToken();
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> logOut() async {
    final token = await _secureStorageService.readToken();
    final response = await http.post(
      Uri.parse('$authBaseURL/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // {'message': 'Logout successful'} is returned after successful logout
      _secureStorageService.deleteToken();
      return decodedBody;
    } else if (response.statusCode == 400) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 401) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden access. You do not have permission to perform this action.');
    } else if (response.statusCode == 429) {
      throw Exception(
          'Too Many Requests. Please wait before sending other one.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else if (response.statusCode == 503) {
      throw Exception(
          'Service Temporarily Unavailable due to overloading or maintenance of the server.');
    } else if (response.statusCode == 504) {
      throw Exception('Gateway Timeout Error.');
    } else {
      throw Exception(decodedBody['message']);
    }
  }

  Future<Map<String, dynamic>> resetPasswordRequest(String email) async {
    final response = await http.post(
      Uri.parse('$authBaseURL/password-reset'),
      body: jsonEncode({"email": email}),
      headers: {'Content-Type': 'application/json'},
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedBody;
    } else if (response.statusCode == 404) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 400) {
      throw Exception(
          (decodedBody['validationErrors'] as Map<String, dynamic>)['message']);
    } else if (response.statusCode == 401) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden access. You do not have permission to perform this action.');
    } else if (response.statusCode == 429) {
      throw Exception(
          'Too Many Requests. Please wait before sending other one.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else if (response.statusCode == 503) {
      throw Exception(
          'Service Temporarily Unavailable due to overloading or maintenance of the server.');
    } else if (response.statusCode == 504) {
      throw Exception('Gateway Timeout Error.');
    }
    throw Exception(decodedBody['message']);
  }

  Future<Map<String, dynamic>> validateToken(String token) async {
    final response = await http.post(
      Uri.parse('$authBaseURL/validate-token?token=$token'),
      headers: {'Content-Type': 'application/json'},
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedBody;
    } else if (response.statusCode == 400) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 401) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden access. You do not have permission to perform this action.');
    } else if (response.statusCode == 429) {
      throw Exception(
          'Too Many Requests. Please wait before sending other one.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else if (response.statusCode == 503) {
      throw Exception(
          'Service Temporarily Unavailable due to overloading or maintenance of the server.');
    } else if (response.statusCode == 504) {
      throw Exception('Gateway Timeout Error.');
    } else {
      throw Exception(decodedBody['message']);
    }
  }

  Future<Map<String, dynamic>> confirmResetPassword(
      String token, String newPassword) async {
    final response = await http.post(
      Uri.parse('$authBaseURL/reset-confirm'),
      body: jsonEncode({
        "token": token,
        "newPassword": newPassword,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedBody;
    } else if (response.statusCode == 400) {
      if ((decodedBody as Map<String, dynamic>)
          .containsKey('validationErrors')) {
        throw Exception((decodedBody['validationErrors']
            as Map<String, dynamic>)['message']);
      }
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 401) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden access. You do not have permission to perform this action.');
    } else if (response.statusCode == 429) {
      throw Exception(
          'Too Many Requests. Please wait before sending other one.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else if (response.statusCode == 503) {
      throw Exception(
          'Service Temporarily Unavailable due to overloading or maintenance of the server.');
    } else if (response.statusCode == 504) {
      throw Exception('Gateway Timeout Error.');
    }
    throw Exception(decodedBody['message']);
  }

  Future<Map<String, dynamic>> sendEmailVerificationOTP(String email) async {
    final response = await http.post(
      Uri.parse('$authBaseURL/send-otp'),
      body: jsonEncode({
        "email": email,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedBody;
    } else if (response.statusCode == 400) {
      if ((decodedBody as Map<String, dynamic>)
          .containsKey('validationErrors')) {
        throw Exception((decodedBody['validationErrors']
            as Map<String, dynamic>)['message']);
      }
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 401) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden access. You do not have permission to perform this action.');
    } else if (response.statusCode == 429) {
      throw Exception(
          'Too Many Requests. Please wait before sending other one.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else if (response.statusCode == 503) {
      throw Exception(
          'Service Temporarily Unavailable due to overloading or maintenance of the server.');
    } else if (response.statusCode == 504) {
      throw Exception('Gateway Timeout Error.');
    }
    throw Exception(decodedBody['message']);
  }

  Future<Map<String, dynamic>> verifyEmailVerificationOTP(
      String email, String otp) async {
    final response = await http.post(
      Uri.parse('$authBaseURL/verify-otp'),
      body: jsonEncode({
        "email": email,
        "otp": otp,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedBody;
    } else if (response.statusCode == 400) {
      if ((decodedBody as Map<String, dynamic>)
          .containsKey('validationErrors')) {
        throw Exception((decodedBody['validationErrors']
            as Map<String, dynamic>)['message']);
      }
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 401) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden access. You do not have permission to perform this action.');
    } else if (response.statusCode == 429) {
      throw Exception(
          'Too Many Requests. Please wait before sending other one.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else if (response.statusCode == 503) {
      throw Exception(
          'Service Temporarily Unavailable due to overloading or maintenance of the server.');
    } else if (response.statusCode == 504) {
      throw Exception('Gateway Timeout Error.');
    }
    throw Exception(decodedBody['message']);
  }

  Future<Map<String, dynamic>> resendEmailVerificationOTP(String email) async {
    final response = await http.post(Uri.parse('$authBaseURL/resend-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": email,
        }));
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedBody;
    } else if (response.statusCode == 400) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 401) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden access. You do not have permission to perform this action.');
    } else if (response.statusCode == 429) {
      throw Exception(
          'Too Many Requests. Please wait before sending other one.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else if (response.statusCode == 503) {
      throw Exception(
          'Service Temporarily Unavailable due to overloading or maintenance of the server.');
    } else if (response.statusCode == 504) {
      throw Exception('Gateway Timeout Error.');
    }
    throw Exception(decodedBody['message']);
  }
}
