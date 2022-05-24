import 'package:barda/models/post.dart';
import 'package:barda/pages/home.dart';
import 'package:barda/pages/person.dart';
import 'package:barda/pages/post.dart';
import 'package:barda/pages/profile.dart';
import 'package:barda/services/auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget generatepost(context, Post post) {
  // Initializing Icon
  var icon = Icons.group;
  if (post.public) {
    icon = Icons.public;
  }

  var date = DateFormat.yMMMMd('en_US').format(post.date),
      time = DateFormat.jm().format(post.date);

  return Container(
    height: 120,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(15))),
    child: Column(children: [
      SizedBox(
          width: double.infinity,
          height: 40,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("@" + post.username,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                      Icon(
                        icon,
                        size: 18,
                        color: Color.fromARGB(255, 97, 97, 97),
                      ),
                    ],
                  )),
            ),
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Person(post.username)));
            },
          )),
      Expanded(
        child: Container(
          width: double.infinity,
          // height: double.infinity,
          decoration: const BoxDecoration(
              color: Color.fromRGBO(55, 55, 55, 1),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: InkWell(
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          post.text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.white),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '$time • $date',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          )),
                    )
                  ],
                ),
                onTap: () {
                  // Go to Post Page
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PostPage(post)));
                },
              )),
        ),
      ),
    ]),
  );
}
