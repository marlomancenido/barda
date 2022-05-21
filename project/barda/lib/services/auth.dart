import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

class Auth {
  static final SESSION = FlutterSession();

  static setToken(String token) async {
    return await SESSION.set('token', token);
  }

  static Future getToken() async {
    return await SESSION.get('token');
  }

  static removeToken() async {
    await SESSION.prefs.clear();
  }
}
