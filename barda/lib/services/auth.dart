import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// AUTH SERVICES
// Handles authorization, setting and retrieval of tokens (username, token)
// and logging out or deauthorization.
// Uses the Flutter Session package.

class Auth {
  static final SESSION = FlutterSession();

  static setToken(String token, String username) async {
    AuthData data = AuthData(token, username);
    return await SESSION.set('token', data);
  }

  static Future getToken() async {
    var token = await SESSION.get('token');
    return token['token'];
  }

  static Future getUsername() async {
    var token = await SESSION.get('token');
    return token['username'];
  }

  static removeToken() async {
    await SESSION.prefs.clear();
  }
}

class AuthData {
  String token, username;
  AuthData(this.token, this.username);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['token'] = token;
    data['username'] = username;
    return data;
  }
}
