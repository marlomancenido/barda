import 'package:barda/extensions/string_extension.dart';
import 'package:barda/services/auth.dart';
import 'package:barda/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  String message = '';
  bool is_public = true;
  TextEditingController controller = TextEditingController();

  Future submitPost(String text, bool audience) async {
    // Get AuthToken
    var token = await Auth.getToken();

    final res = await http.post(
        Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'text': text,
          'public': audience,
        }));

    var jsonData = jsonDecode(res.body);
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20, left: 20),
                child: Text(
                  'Create',
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
                    padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: TextField(
                      controller: controller,
                      onChanged: (value) => message = value,
                      maxLines: 3,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: 'What\'s happening?',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1),
                          )),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Audience:',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 15),
                        ),
                        Row(
                          children: [
                            IconButton(
                              iconSize: 35,
                              icon: Icon(
                                Icons.public,
                                color: is_public
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  is_public = true;
                                });
                              },
                            ),
                            IconButton(
                              iconSize: 35,
                              icon: Icon(
                                Icons.group,
                                color: is_public
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.secondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  is_public = false;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(2000)))),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Post',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      onPressed: () async {
                        var response = await submitPost(message, is_public);

                        if (response['success']) {
                          setState(() {
                            message = '';
                            is_public = true;
                            controller.clear();
                          });
                          showSuccess(context, 'Successfully published post!');
                        } else {
                          var statusCode = response['statusCode'];
                          var message =
                              response['message'].toString().toCapitalized();
                          showError(context, statusCode, message);
                        }
                      }),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
