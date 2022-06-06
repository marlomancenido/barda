import 'dart:convert';
import 'package:barda/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth.dart';

// CHANGE PASS WIDGET
// A sub-page of profile that handles any changes to the user's password.
// Also contains the function for changing password.

class ChangePass extends StatefulWidget {
  final String username, firstName, lastName;

  const ChangePass(this.username, this.firstName, this.lastName);

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  // Change Password
  // Changes user's password.
  // Returns response body for success/error handling.
  Future changePassword(String oldPass, String newPass) async {
    // Retrieve Token
    final token = await Auth.getToken(),
        username = widget.username,
        firstname = widget.firstName,
        lastname = widget.lastName;

    final uri = Uri.https(
      'cmsc-23-2022-bfv6gozoca-as.a.run.app',
      '/api/user/$username',
    );
    final res = await http.put(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          'oldPassword': oldPass,
          'newPassword': newPass,
          'firstName': firstname,
          'lastName': lastname
        }));

    var jsonData = jsonDecode(res.body);
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController oldpass = TextEditingController();
    TextEditingController newpass = TextEditingController();
    TextEditingController newpass_c = TextEditingController();

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: const EdgeInsets.only(top: 50, left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(2000)))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new,
                      size: 15, color: Colors.black),
                  label: const Text(
                    'Back',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20),
                child: Text(
                  'Change Password',
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25))),
                  child: Column(children: [
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 30),
                        child: Column(
                          children: [
                            Text(
                              'Old Password',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextField(
                                  obscureText: true,
                                  controller: oldpass,
                                  // onChanged: (value) => message = value,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  decoration: InputDecoration(
                                      hintText: 'Enter old password',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1000)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(1000)),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 1),
                                      )),
                                )),
                            const Divider(),
                            Text(
                              'New Password',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextField(
                                  obscureText: true,
                                  controller: newpass,
                                  // onChanged: (value) => message = value,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  decoration: InputDecoration(
                                      hintText: 'Enter new password',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1000)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(1000)),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 1),
                                      )),
                                )),
                            const Divider(),
                            Text(
                              'Repeat New Password',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextField(
                                  obscureText: true,
                                  controller: newpass_c,
                                  // onChanged: (value) => message = value,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  decoration: InputDecoration(
                                      hintText: 'Repeat new password',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1000)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(1000)),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 1),
                                      )),
                                )),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(2000)))),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        onPressed: () async {
                          if (newpass_c.text != newpass.text) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    text: 'New passwords don\'t match!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              ' Please re-enter new password.',
                                          style: TextStyle(
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
                                width:
                                    MediaQuery.of(context).size.width * 0.8));
                            newpass_c.clear();
                          } else if (oldpass.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    text: 'Old password can\'t be empty.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              ' Please re-enter your old password.',
                                          style: TextStyle(
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
                                width:
                                    MediaQuery.of(context).size.width * 0.8));
                          } else {
                            var response = await changePassword(
                                oldpass.text, newpass.text);

                            if (response['success']) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          text: 'Success!',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: ' Password is changed.',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      padding: const EdgeInsets.all(20),
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      width: MediaQuery.of(context).size.width *
                                          0.8));
                              Navigator.pop(context);
                              setState(() {});
                            } else {
                              var statusCode = response['statusCode'];
                              var message = response['message']
                                  .toString()
                                  .toCapitalized();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: 'Error $statusCode.',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white),
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
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      width: MediaQuery.of(context).size.width *
                                          0.8));
                              newpass_c.clear();
                              newpass.clear();
                              oldpass.clear();
                            }
                          }

                          // var response =
                          //     await userLogout(token);

                          // if (response['success']) {
                          //   Navigator.popAndPushNamed(
                          //       context, '/splash');
                          // }
                        },
                      ),
                    )
                  ])))
        ]));
  }
}
