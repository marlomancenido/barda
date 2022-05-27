import 'package:barda/extensions/string_extension.dart';
import 'package:barda/models/user.dart';
import 'package:barda/widgets/person_posts.dart';
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
