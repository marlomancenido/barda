import 'dart:convert';
import 'package:http/http.dart' as http;
import '../extensions/string_extension.dart';
import 'package:barda/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future userLogout(String token) async {
    final res = await http.post(
        Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/logout'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        });

    var jsonData = jsonDecode(res.body);
    if (jsonData['success'] == true) {
      Auth.removeToken();
    }
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          ElevatedButton(
            child: Text('Log Out'),
            onPressed: () async {
              var token = await Auth.getToken();
              var response = await userLogout(token);

              if (response['success']) {
                Navigator.popAndPushNamed(context, '/splash');
              } else {
                var statusCode = response['statusCode'];
                var message = response['message'].toString().toCapitalized();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Error $statusCode.',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, color: Colors.white),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' $message.',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                    behavior: SnackBarBehavior.floating,
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    width: MediaQuery.of(context).size.width * 0.8));
              }
            },
          )
        ]));
  }
}
