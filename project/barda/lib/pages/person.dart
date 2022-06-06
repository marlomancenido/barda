import 'dart:convert';

import 'package:barda/extensions/string_extension.dart';
import 'package:barda/models/user.dart';
import 'package:barda/widgets/person_posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../services/auth.dart';
import '../widgets/error.dart';

class Person extends StatefulWidget {
  final String username;

  const Person(this.username);

  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {
  late dynamic _userdata;
  var is_following = 0;

  Future followuser() async {
    var username = widget.username;
    // Retrieve Token and Username
    final token = await Auth.getToken();
    final uri = Uri.https(
        'cmsc-23-2022-bfv6gozoca-as.a.run.app', '/api/follow/$username');
    final res = await http.post(
      uri,
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    var jsonData = jsonDecode(res.body);

    if (jsonData['success']) {
      setState(() {
        Navigator.pop(context);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Person(widget.username)));
      });
    }

    return jsonData;
  }

  Future unfollow() async {
    // Get AuthToken
    var token = await Auth.getToken();

    var username = widget.username;

    final res = await http.delete(
        Uri.parse(
            'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/follow/$username'),
        headers: <String, String>{'Authorization': 'Bearer $token'});

    var jsonData = jsonDecode(res.body);
    if (jsonData['success']) {
      setState(() {
        Navigator.pop(context);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Person(widget.username)));
      });
    }
    return jsonData;
  }

  @override
  void initState() {
    super.initState();
    _userdata = getUserData(widget.username);
  }

  getShortForm(int numbers) {
    var f = NumberFormat.compact(locale: "en_US");
    return f.format(numbers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        body: FutureBuilder(
            future: _userdata,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final username = snapshot.data['username'];
                final display_followers =
                    getShortForm(snapshot.data['followers_count']);
                final firstName = snapshot.data['firstName'];
                final lastName = snapshot.data['lastName'];
                is_following = snapshot.data['friendStat'];
                return Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    body: Column(children: [
                      Container(
                        height: 320,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(children: [
                              (Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/default_cover.png"),
                                        fit: BoxFit.cover)),
                                height: 200,
                              ))
                            ]),
                            Positioned(
                              top: 150,
                              child: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/default_dp.png"),
                                        fit: BoxFit.cover)),
                                height: 150,
                                width: 150,
                              ),
                            ),
                            Positioned(
                                left: 10,
                                top: 50,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(2000)))),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios_new,
                                      size: 15, color: Colors.black),
                                  label: Text(
                                    'Back',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Text(
                        '$firstName $lastName',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      Text(
                        '@$username',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      Divider(),
                      is_following == 0
                          ? ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(2000)))),
                              onPressed: () async {
                                var response = await followuser();
                                if (response['success']) {
                                  is_following = 1;
                                  showSuccess(context,
                                      'Successfully followed @$username!');
                                } else {
                                  var statusCode = response['statusCode'];
                                  var message = response['message']
                                      .toString()
                                      .toCapitalized();
                                  showError(context, statusCode, message);
                                }
                              },
                              icon: Icon(Icons.person_add,
                                  size: 15,
                                  color: Theme.of(context).colorScheme.primary),
                              label: Text(
                                'Follow',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            )
                          : is_following == 1
                              ? ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(2000)))),
                                  onPressed: () async {
                                    var response = await unfollow();
                                    if (response['success']) {
                                      showSuccess(context,
                                          'Successfully unfollowed @$username!');
                                    } else {
                                      var statusCode = response['statusCode'];
                                      var message = response['message']
                                          .toString()
                                          .toCapitalized();
                                      showError(context, statusCode, message);
                                    }
                                  },
                                  icon: Icon(Icons.person_remove,
                                      size: 15, color: Colors.black),
                                  label: Text(
                                    'Unfollow',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              : Container(),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 0),
                        child: PersonPosts(username),
                      ))
                    ]));
              } else {
                return Center(
                  child: CupertinoActivityIndicator(
                      color: Theme.of(context).colorScheme.secondary),
                );
              }
            }));
  }
}
