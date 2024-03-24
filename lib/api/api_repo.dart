import 'dart:io';

import 'api_model.dart';
import 'api_provider.dart';

import 'package:http/http.dart' as http;

class ApiRepository {
  final ApiProvider _api = ApiProvider();

  Future<ApiResponse<dynamic>> getLoginOtp(String username) async =>
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

  Future<ApiResponse<dynamic>> findMember(
          String dist, String mek, String search) async =>
      await _api.findMember(dist, mek, search);

  Future<ApiResponse<dynamic>> getMekhala(String id) async =>
      await _api.getMekhala(id);

  Future<ApiResponse<dynamic>> getDistrict() async => await _api.getDistrict();

  Future<ApiResponse<dynamic>> getFamilyMembers() async =>
      await _api.getFamilyMembers();

  Future<ApiResponse<dynamic>> getRelations() async =>
      await _api.getRelations();

  Future<ApiResponse<dynamic>> addFamilyMember(dynamic data, String id) async =>
      await _api.addFamilyMember(data, id);

  Future<ApiResponse<dynamic>> unlinkShare(String type, String id) async =>
      await _api.unlinkShare(type, id);

  Future<ApiResponse<dynamic>> linkShare(String type, String id) async =>
      await _api.linkShare(type, id);

  Future<ApiResponse<dynamic>> searchShare(String type, String search) async =>
      await _api.searchShare(type, search);
}
