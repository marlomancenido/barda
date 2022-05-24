import 'package:barda/models/post.dart';
import 'package:flutter/material.dart';

Widget generatepost(context, Post post) {
  // Initializing Icon
  var icon = Icons.group;
  if (post.public) {
    icon = Icons.public;
  }

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
            onTap: () {
              print('Name tapped');
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
                child: Text(
                  post.text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
                onTap: () {
                  // Go to Post Page
                  print("Tapped!!!");
                },
              )),
        ),
      ),
    ]),
  );
}
