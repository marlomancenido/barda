import 'package:barda/extensions/string_extension.dart';
import 'package:barda/models/user.dart';
import 'package:barda/pages/person_posts.dart';
import 'package:flutter/material.dart';

class Person extends StatefulWidget {
  final String username;

  const Person(this.username);

  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {
  @override
  Widget build(BuildContext context) {
    var person_username = widget.username;
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
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/default_cover.png"),
                              fit: BoxFit.cover)),
                      height: 200,
                    ),
                  ]),
                  Positioned(
                    top: 150,
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("assets/images/default_dp.png"),
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
              '@$person_username',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(2000)))),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Log Out',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              onPressed: () async {
                // var response = await followUser(person_username);
                followUser(person_username);

                // if (response['success']) {
                //   Navigator.popAndPushNamed(context, '/splash');
                // } else {
                //   var statusCode = response['statusCode'];
                //   var message = response['message'].toString().toCapitalized();
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //       content: RichText(
                //         textAlign: TextAlign.center,
                //         text: TextSpan(
                //           text: 'Error $statusCode.',
                //           style: const TextStyle(
                //               fontWeight: FontWeight.w800, color: Colors.white),
                //           children: <TextSpan>[
                //             TextSpan(
                //                 text: ' $message.',
                //                 style: const TextStyle(
                //                     fontWeight: FontWeight.w500,
                //                     color: Colors.white)),
                //           ],
                //         ),
                //       ),
                //       behavior: SnackBarBehavior.floating,
                //       padding: const EdgeInsets.all(20),
                //       backgroundColor: Colors.red,
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(30)),
                //       width: MediaQuery.of(context).size.width * 0.8));
                // }
              },
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: Column(children: [
                    Expanded(child: PersonPosts(person_username))
                  ])),
            ),
          ],
        ));
  }
}
