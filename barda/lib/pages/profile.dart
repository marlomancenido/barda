import 'package:barda/models/user.dart';
import 'package:barda/widgets/generate_friends.dart';
import 'package:barda/widgets/user_posts.dart';
import 'package:barda/widgets/changepass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../extensions/string_extension.dart';
import 'package:barda/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// PROFILE PAGE
// Displays auth user's profile. Contains list of friends/following, posts, and settings
// for logging out and changing password.
// Contains function for handling logout.

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late dynamic _authuserdata;

  @override
  void initState() {
    super.initState();
    _authuserdata = getAuthUserData();
  }

  // Get Short Form
  // Should the user's number of followers be long, this gets its short form.
  // ex: 15390200 -> 15.3M
  getShortForm(int numbers) {
    var f = NumberFormat.compact(locale: "en_US");
    return f.format(numbers);
  }

  // User Logout
  // Logs out the user. Returns response body for success/error handling
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
    return DefaultTabController(
        length: 3,
        child: FutureBuilder(
          future: _authuserdata,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final username = snapshot.data['username'];
              final display_followers =
                  getShortForm(snapshot.data['followers_count']);
              final firstName = snapshot.data['firstName'];
              final lastName = snapshot.data['lastName'];
              return Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  body: Column(
                    children: [
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
                        '@$username ??? $display_followers friends',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 30),
                          child: Column(
                            children: [
                              TabBar(
                                isScrollable: false,
                                labelPadding: const EdgeInsets.all(10),
                                indicatorColor:
                                    Theme.of(context).colorScheme.secondary,
                                labelColor:
                                    Theme.of(context).colorScheme.secondary,
                                unselectedLabelColor: Colors.white,
                                tabs: const [
                                  Text(
                                    'Posts',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  Icon(
                                    Icons.group,
                                    key: Key('friends_btn'),
                                  ),
                                  Icon(
                                    Icons.settings,
                                    key: Key('settings_btn'),
                                  )
                                ],
                              ),
                              Expanded(
                                  child: TabBarView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  // UserPosts generates the posts by the user and the pagination.
                                  // This is from user_posts in the widgets folder
                                  const UserPosts(),
                                  Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, left: 20),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Friends',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )),

                                      // Gen Friends
                                      // Generates the list of friends by the user. This
                                      // is from generate_friends under the widgets folder.
                                      const GenFriends()
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 10, left: 20),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'User Settings',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )),
                                      Card(
                                        color: Colors.transparent,
                                        elevation: 0,
                                        child: ListTile(
                                            key: Key('ch_pass'),
                                            trailing: const IconButton(
                                                onPressed: null,
                                                icon: Icon(Icons.chevron_right,
                                                    color: Color.fromARGB(
                                                        255, 190, 190, 190))),
                                            textColor: Colors.white,
                                            title: const Text('Change Password',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                )),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChangePass(
                                                              username,
                                                              firstName,
                                                              lastName)));
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: ElevatedButton(
                                          key: Key('logout_btn'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              2000)))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Text(
                                              'Log Out',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                          ),
                                          onPressed: () async {
                                            var token = await Auth.getToken();
                                            var response =
                                                await userLogout(token);

                                            if (response['success']) {
                                              Navigator.popAndPushNamed(
                                                  context, '/splash');
                                            } else {
                                              var statusCode =
                                                  response['statusCode'];
                                              var message = response['message']
                                                  .toString()
                                                  .toCapitalized();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: RichText(
                                                        textAlign:
                                                            TextAlign.center,
                                                        text: TextSpan(
                                                          text:
                                                              'Error $statusCode.',
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: Colors
                                                                      .white),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    ' $message.',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white)),
                                                          ],
                                                        ),
                                                      ),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      backgroundColor:
                                                          Colors.red,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8));
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ));
            } else {
              return const CupertinoActivityIndicator(color: Colors.white);
            }
          },
        ));
  }
}
