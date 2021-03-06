import 'package:barda/models/user.dart';
import 'package:barda/widgets/friend_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// GENERATE FRIENDS WIDGET
// Generates the friends list in profile. Calls friend_card for each friend.

class GenFriends extends StatefulWidget {
  const GenFriends({Key? key}) : super(key: key);

  @override
  State<GenFriends> createState() => _GenFriendsState();
}

class _GenFriendsState extends State<GenFriends> {
  late Future<List<String>> _friendslist;

  @override
  void initState() {
    super.initState();
    _friendslist = getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: (FutureBuilder(
          future: _friendslist,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const CupertinoActivityIndicator(color: Colors.white);
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: friend_card(context, snapshot.data[index]),
                          );
                        }),
                  ))
                ],
              );
            }
          })),
    );
  }
}
