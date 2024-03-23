import 'dart:io';

import 'api_model.dart';
import 'api_provider.dart';

import 'package:http/http.dart' as http;

class ApiRepository {
  final ApiProvider _api = ApiProvider();

  Future<ApiResponse<dynamic>> getLoginOtp(
          String username) async =>
      await _api.getLoginOtp(username);

  Future<ApiResponse<dynamic>> getLoginWithOtp(
      String username, String otp) async =>
      await _api.getLoginWithOtp(username, otp);

  Future<ApiResponse<dynamic>> getDashboard() async =>
      await _api.getDashboard();

  Future<ApiResponse<dynamic>> updateProfilePhoto(
      String username, File photo) async =>
      await _api.updateProfile(photo, username);

  Future<ApiResponse<dynamic>> getShareDetails() async =>
      await _api.getShareDetails();

  Future<ApiResponse<dynamic>> getFamilyMembers() async =>
      await _api.getFamilyMembers();

  Future<ApiResponse<dynamic>> getRelations() async =>
      await _api.getRelations();

  Future<ApiResponse<dynamic>> addFamilyMember(dynamic data, String id) async =>
      await _api.addFamilyMember(data, id);

}
