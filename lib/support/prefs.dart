import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static Future<void> setToken(String? token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('token', token ?? '');
  }

  static Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token');
  }

  static Future<void> setFCMToken(String? token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('fcm_token', token ?? '');
  }

  static Future<String?> getFCMToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('fcm_token');
  }

  static Future<void> setUser(String? token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('user', token ?? '');
  }

  static Future<void> setDash(String? token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('dash', token ?? '');
  }

  static Future<void> setUserType(String? token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('userType', token ?? '');
  }

  static Future<String?> getUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('user');
  }

  static Future<String?> getDash() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('dash');
  }

  static Future<String?> getUserType() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('userType');
  }

  static Future<String?> getTicketType() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('ticketTypes');
  }

  static Future<void> setTicketType(String? token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('ticketTypes', token ?? '');
  }

  static Future<String?> getIssueCategories() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('issueCategories');
  }

  static Future<void> setIssueCategories(String? token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('issueCategories', token ?? '');
  }

  static Future<String?> getIssueTypes() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('issueTypes');
  }

  static Future<void> setIssueTypes(String? token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('issueTypes', token ?? '');
  }

  static Future<String?> getStatus() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('status');
  }

  static Future<void> setStatus(String? token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('status', token ?? '');
  }

  // static Future<AppDatabase> getDatabase() async =>
  //     await $FloorAppDatabase.databaseBuilder('app_database.db').build();
}
