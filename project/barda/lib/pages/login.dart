import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Authentication with ChangeNotifier {
  late String loginToken;

  Future userLogin(String username, String password) async {
    final res = await http.post(
        Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer Zxi!!YbZ4R9GmJJ!h5tJ9E5mghwo4mpBs@*!BLoT6MFLHdMfUA%'
        },
        body: jsonEncode(<String, dynamic>{
          'username': username,
          'password': password,
        }));

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      print(jsonData);
    }
  }
}
