import 'package:barda/widgets/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "../extensions/string_extension.dart";

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/auth.dart';

// Splash
// Contains the splash screen or the landing page for the app. Here, the user logs in on registers

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // User Login
  // Logs user in through the API
  // Will set token  if success, else displays the error
  // Returns entire response body
  Future userLogin(String username, String password) async {
    final res = await http.post(
        Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer Zxi!!YbZ4R9GmJJ!h5tJ9E5mghwo4mpBs@*!BLoT6MFLHdMfUA%'
        },
        body: jsonEncode(<String, dynamic>{
          'username': username,
          'password': password,
        }));

    var jsonData = jsonDecode(res.body);
    if (jsonData['success'] == true) {
      String token = jsonData['data']['token'];
      Auth.setToken(token, username);
    }
    return jsonData;
  }

  // User Register
  // Registers a user through the API
  // Returns entire response body
  Future userRegister(String username, String password, String firstname,
      String lastname) async {
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
          'firstName': firstname,
          'lastName': lastname
        }));
    var jsonData = jsonDecode(res.body);
    return jsonData;
  }

  // Login Sheet
  // Displays a bottom modal sheet that contains the sign in form
  // Shows error if any or redirects user to the home page if success
  loginSheet(BuildContext context) {
    String username = '', password = '';
    final _formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Log in to Account',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 25),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            onChanged: (String value) {
                              username = value;
                            },
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            decoration: const InputDecoration(
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300)),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Username can\'t be empty.';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            onChanged: (String value) {
                              password = value;
                            },
                            obscureText: true,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            decoration: const InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300)),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Password can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ]),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var response =
                                    await userLogin(username, password);
                                if (response['success']) {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/home');
                                } else {
                                  var statusCode = response['statusCode'];
                                  var message = response['message']
                                      .toString()
                                      .toCapitalized();
                                  Navigator.pop(context);
                                  showError(context, statusCode, message);
                                }
                              }
                              ;
                            },
                            style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(2000)))),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                'Log in',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.left,
                              ),
                            )))
                  ],
                ),
              ));
        });
  }

  // Reg Sheet
  // Displays a bottom modal sheet that contains the sign up form
  // Shows if success or not in registering new user
  regSheet(BuildContext context) {
    String username = '', password = '', firstName = '', lastName = '';
    final _formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Make a New Account',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 25),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            onChanged: (String value) {
                              firstName = value;
                            },
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            decoration: const InputDecoration(
                                hintText: 'First Name',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300)),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'First name can\'t be empty.';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            onChanged: (String value) {
                              lastName = value;
                            },
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            decoration: const InputDecoration(
                                hintText: 'Last Name',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300)),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Last name can\'t be empty.';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            onChanged: (String value) {
                              username = value;
                            },
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            decoration: const InputDecoration(
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300)),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Username can\'t be empty.';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            onChanged: (String value) {
                              password = value;
                            },
                            obscureText: true,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            decoration: const InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300)),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Password can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ]),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var response = await userRegister(
                                    username, password, firstName, lastName);
                                var status, message, color;

                                if (response['success']) {
                                  message = 'Account successfully created!';
                                  Navigator.pop(context);
                                  showSuccess(context, message);
                                } else {
                                  message = response['message'];
                                  message = message.toString().toCapitalized();
                                  Navigator.pop(context);
                                  showError(
                                      context, response['statusCode'], message);
                                }
                              }
                              ;
                            },
                            style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(2000)))),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.left,
                              ),
                            )))
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            // alignment: Alignment.center,
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.tertiary),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                      child: RichText(
                        text: TextSpan(
                          text: 'oras na para\nmakipag-',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 30,
                              color: Colors.white),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'barda',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 35,
                                    color: Theme.of(context).primaryColor)),
                            const TextSpan(text: 'han!'),
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                    child: Row(
                      children: <Widget>[
                        OutlinedButton(
                            onPressed: () {
                              setState(() {
                                loginSheet(context);
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                              child: Text(
                                'log in',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2000))),
                              side: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextButton(
                              onPressed: () {
                                regSheet(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Text(
                                  'create an account',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2000))))),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                    child: RichText(
                        text: TextSpan(
                            text: 'By signing up, you agree to all our ',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                            children: <TextSpan>[
                          TextSpan(
                              text: 'conditions',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                  decorationColor:
                                      Theme.of(context).colorScheme.secondary))
                        ])),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 300, bottom: 50),
                    child: Text(
                      'Made by: Marlo Fiel Mancenido',
                      style: TextStyle(
                          fontSize: 8,
                          color: Theme.of(context).colorScheme.secondary),
                      textAlign: TextAlign.left,
                    ),
                  )
                ])));
    ;
  }
}
