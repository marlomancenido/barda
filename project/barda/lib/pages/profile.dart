import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../extensions/string_extension.dart';
import 'package:barda/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String firstName = 'Leni', lastName = 'Robredo';
  int noFriends = 31000000;

  getShortForm(var number) {
    var f = NumberFormat.compact(locale: "en_US");
    return f.format(number);
  }

  dateTimeFromStamp(int datetime) {
    return DateTime.fromMicrosecondsSinceEpoch(datetime);
  }

  // Function to get User Details

  Future userLogout(String token) async {
    final res = await http.post(
        Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/logout'),
        headers: <String, String>{
          'Authorization': 'Bearer $token 1',
        });

    var jsonData = jsonDecode(res.body);
    if (jsonData['success'] == true) {
      Auth.removeToken();
    }
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    var friendCount = getShortForm(noFriends);

    // For testing Only
    int sample = 1653237558673422;
    var newDate = dateTimeFromStamp(sample);
    print(DateFormat.jm().format(newDate));

    return DefaultTabController(
        length: 2,
        child: Scaffold(
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
                  '$friendCount friends',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                    child: Column(
                      children: [
                        TabBar(
                          isScrollable: false,
                          labelPadding: EdgeInsets.all(10),
                          indicatorColor:
                              Theme.of(context).colorScheme.secondary,
                          labelColor: Theme.of(context).colorScheme.secondary,
                          unselectedLabelColor: Colors.white,
                          tabs: [
                            Text(
                              'Posts',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Icon(Icons.settings)
                          ],
                        ),
                        Expanded(
                            child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Column(
                              children: [
                                Divider(
                                  height: 20,
                                ),
                                Container(
                                  height: 200,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                          style: ButtonStyle(
                                            overlayColor: MaterialStateProperty
                                                .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                              if (states.contains(
                                                  MaterialState.focused))
                                                return Colors.transparent;
                                              if (states.contains(
                                                  MaterialState.hovered))
                                                return Colors.transparent;
                                              if (states.contains(
                                                  MaterialState.pressed))
                                                return Color.fromARGB(
                                                    10, 58, 58, 58);
                                              return Colors
                                                  .transparent; // Defer to the widget's default.
                                            }),
                                          ),
                                          onPressed: () {
                                            print("pressed!");
                                          },
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Leni Robredo',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600)))),
                                    ),
                                  ]),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
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
                                const Card(
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: ListTile(
                                    trailing: IconButton(
                                        onPressed: null,
                                        icon: Icon(Icons.chevron_right,
                                            color: Color.fromARGB(
                                                255, 190, 190, 190))),
                                    textColor: Colors.white,
                                    title: Text('Change Name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        )),
                                    onTap: null,
                                  ),
                                ),
                                const Card(
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: ListTile(
                                    trailing: IconButton(
                                        onPressed: null,
                                        icon: Icon(Icons.chevron_right,
                                            color: Color.fromARGB(
                                                255, 190, 190, 190))),
                                    textColor: Colors.white,
                                    title: Text('Change Password',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        )),
                                    onTap: null,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(2000)))),
                                    child: Padding(
                                      padding: EdgeInsets.all(15),
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
                                      var response = await userLogout(token);

                                      if (response['success']) {
                                        Navigator.popAndPushNamed(
                                            context, '/splash');
                                      } else {
                                        var statusCode = response['statusCode'];
                                        var message = response['message']
                                            .toString()
                                            .toCapitalized();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    text: 'Error $statusCode.',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.white),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: ' $message.',
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white)),
                                                    ],
                                                  ),
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                padding:
                                                    const EdgeInsets.all(20),
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                width: MediaQuery.of(context)
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
            )));
  }
}
