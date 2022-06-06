import 'package:flutter/material.dart';
import '../pages/person.dart';

// FRIEND CARD WIDGET
// Used for generating the friends list of the user.

Widget friend_card(context, String username) {
  return Card(
    color: Colors.transparent,
    elevation: 0,
    child: ListTile(
      key: Key('friendcard'),
      trailing: const IconButton(
          onPressed: null,
          icon: Icon(Icons.chevron_right,
              color: Color.fromARGB(255, 190, 190, 190))),
      textColor: Colors.white,
      title: Text('@$username',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          )),
      onTap: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Person(username)));
      },
    ),
  );
}
