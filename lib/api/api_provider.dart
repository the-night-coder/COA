import 'dart:io';

import '../support/prefs.dart';
import 'api_error.dart';
import 'api_model.dart';
import 'package:http/http.dart' as http;

import 'c.dart';

class ApiProvider {
  final String _url = C.baseUrl;

  Future<ApiResponse<dynamic>> getLoginOtp(String uname) async {
    try {
      var uri = Uri.parse('$_url${C.loginOtp}');
      var request = http.MultipartRequest(
        'POST',
        uri,
      );
      request.fields.addAll({
        'mobile': uname,
      });
      var res = await request.send();
      return returnResponse(await http.Response.fromStream(res));
    } catch (e) {
      return ApiResponse.error('No Internet connection');
    }
  }

  Future<ApiResponse<dynamic>> getLoginWithOtp(String uname, String otp) async {
    try {
      var uri = Uri.parse('$_url${C.loginWithOtp}');
      var request = http.MultipartRequest(
        'POST',
        uri,
      );
      request.fields.addAll({'mobile': uname, 'otp': otp});
      var res = await request.send();
      return returnResponse(await http.Response.fromStream(res));
    } catch (e) {
      return ApiResponse.error('No Internet connection');
    }
  }

  Future<ApiResponse<dynamic>> getDashboard() async {
    try {
      var uri = Uri.parse('$_url${C.dashboard}');
      var token = await Pref.getToken() ?? '';
      var request = http.MultipartRequest(
        'GET',
        uri,
      );
      request.headers.addAll({'Authorization': 'Bearer $token'});
      var res = await request.send();
      return returnResponse(await http.Response.fromStream(res));
    } catch (e) {
      return ApiResponse.error('No Internet connection');
    }
  }

  Future<ApiResponse<dynamic>> updateProfile(File photo, String username) async {
    try {
      var uri = Uri.parse('$_url${C.updateProfilePhoto}');
      var token = await Pref.getToken() ?? '';
      var request = http.MultipartRequest(
        'POST',
        uri,
      );
      request.headers.addAll({'Authorization': 'Bearer $token'});
      request.fields.addAll({'username': username});
      request.files
          .add(await http.MultipartFile.fromPath('profile_photo', photo.path));
      var res = await request.send();
      return returnResponse(await http.Response.fromStream(res));
    } catch (e) {
      return ApiResponse.error('No Internet connection');
    }
  }

  Future<ApiResponse<dynamic>> getShareDetails() async {
    try {
      var uri = Uri.parse('$_url${C.shareDetails}');
      var token = await Pref.getToken() ?? '';
      var request = http.MultipartRequest(
        'GET',
        uri,
      );
      request.headers.addAll({'Authorization': 'Bearer $token'});
      var res = await request.send();
      return returnResponse(await http.Response.fromStream(res));
    } catch (e) {
      return ApiResponse.error('No Internet connection');
    }
  }

  Future<ApiResponse<dynamic>> getSliders() async {
    try {
      var uri = Uri.parse('$_url${C.sliders}');
      var token = await Pref.getToken() ?? '';
      var request = http.MultipartRequest(
        'GET',
        uri,
      );
      request.headers.addAll({'Authorization': 'Bearer $token'});
      var res = await request.send();
      return returnResponse(await http.Response.fromStream(res));
    } catch (e) {
      return ApiResponse.error('No Internet connection');
    }
  }
}
