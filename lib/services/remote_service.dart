import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RemoteServices {
  static var client = http.Client();
  static String url = 'https://dev.gravitycustoms.net/auth/api/';

  //login
  static Future<Response> login(String emailId, String password) async {
    try {
      print('${url}login/');
      String apiUrl = '${url}login/';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> requestBody = {
        "email": emailId,
        "password": password,
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //registration
  static Future<Response> userSignUp(String fName, String lName, String email,
      String mobileNo, String password) async {
    try {
      print('${url}register/');
      String apiUrl = '${url}register/';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> requestBody = {
        "first_name": fName,
        "last_name": lName,
        "phone_number": mobileNo,
        "email": email,
        "password": password,
        "role": "customer",
        "address": ""
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Verify Email
  static Future<Response> verifyMail(String email) async {
    try {
      print('${url}/verify-email/');
      String apiUrl = '$url/verify-email/';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> requestBody = {
        "email": email,
      };
      print(requestBody);

      // Use http.get instead of http.post
      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

//forgot password
  static Future<Response> resetPassword(String emailId) async {
    try {
      print('${url}reset-password/');
      String apiUrl = '${url}reset-password/';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> requestBody = {
        "email": emailId,
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

//change password
  static Future<Response> changePassword(String token, String password) async {
    try {
      print('${url}change-password/');
      String apiUrl = '${url}change-password/';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      print(headers);
      Map<String, dynamic> requestBody = {
        "password": password,
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

}
