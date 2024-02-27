import 'dart:convert';
import 'package:http/http.dart';

import 'api_model.dart';

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

const _defaultMessage = 'Something went wrong!';

ApiResponse<dynamic> returnResponse(Response response) {
  print(response.body.toString());
  switch (response.statusCode) {
    case 200:
      if (jsonDecode(response.body)['status'] == 1 ||
          jsonDecode(response.body)['status'] == '1' ||
          jsonDecode(response.body)['status'] == true ||
          jsonDecode(response.body)['status'] == 'true') {
        return ApiResponse.data(jsonDecode(response.body));
      } else {
        return ApiResponse.error(jsonDecode(response.body)['message']);
      }
    case 400:
      return ApiResponse.error('Bad Request!');
    case 401:
    case 403:
      return ApiResponse.error('Unauthorized!');
    case 500:
    default:
      return ApiResponse.error(_defaultMessage);
  }
}

ApiResponse<dynamic> returnSurepassResponse(Response response) {
  print(response.body.toString());
  switch (response.statusCode) {
    case 200:
      if (jsonDecode(response.body)['success'] ?? false == true) {
        return ApiResponse.data(jsonDecode(response.body));
      } else {
        return ApiResponse.error(jsonDecode(response.body)['message']);
      }
    case 400:
      return ApiResponse.error('Bad Request!');
    case 401:
    case 403:
      return ApiResponse.error('Unauthorized!');
    case 500:
    default:
      return ApiResponse.error(_defaultMessage);
  }
}
