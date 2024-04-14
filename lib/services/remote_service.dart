import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RemoteServices {
  static var client = http.Client();
  static String url = 'https://gravitycustoms.net/auth/api/';
  static String carUrl = 'https://carapi.app/api/';
  static String bookingUrl = 'https://gravitycustoms.net/';

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

  static Future<Response> performCarLogin() async {
    String apiUrl = '${carUrl}auth/login';
    print(apiUrl);

    Map<String, String> payload = {
      "api_token": "758d2b2c-2c0c-4385-85d1-23438c97a7db",
      "api_secret": "72c8c5d91961aab47966e5dce963646a"
    };

    Map<String, String> headers = {
      'accept': 'text/plain',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to perform car login: ${response.body}');
    }
  }

  static Future<Response> getCarBuildYears(String jwtToken) async {
    String apiUrl = '${carUrl}years';

    try {
      Map<String, String> headers = {
        'accept': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to load car build years: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<Response> getCarNames(String jwtToken, int carYear) async {
    try {
      String apiUrl = '${carUrl}makes?limit=200&year=$carYear';

      print(apiUrl);
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load car names');
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<Response> getCarModel(String jwtToken, int carNameId) async {
    try {
      String apiUrl = '${carUrl}models?limit=100&make_id=$carNameId';

      print(apiUrl);
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load car names');
      }
    } catch (error) {
      rethrow;
    }
  }

  //Add Car
  static Future<Response> addCar(String token, String carBrand, String carModel,
      String carModelYear, String carType) async {
    try {
      print('${bookingUrl}booking/cars/');
      String apiUrl = '${bookingUrl}booking/cars/';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      };
      Map<String, dynamic> requestBody = {
        "car_brand": carBrand,
        "car_model": carModel,
        "car_model_year": carModelYear,
        "car_type": carType,
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

  //fetch Car details
  static Future<Response> fetchCars(String token) async {
    try {
      print('${bookingUrl}booking/cars/');
      String apiUrl = '${bookingUrl}booking/cars/';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      };
     
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

//delete car
  static Future<Response> deleteCars(String token,String id) async {
    try {
      print('${bookingUrl}booking/cars/$id/');
      String apiUrl = '${bookingUrl}booking/cars/$id/';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      };
     
      http.Response response = await http.delete(
        Uri.parse(apiUrl),
        headers: headers,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

   //fetch Car Category
  static Future<Response> fetchCarCategory(String token) async {
    try {
      print('${bookingUrl}booking/get-category/');
      String apiUrl = '${bookingUrl}booking/get-category/';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      };
     
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


}
