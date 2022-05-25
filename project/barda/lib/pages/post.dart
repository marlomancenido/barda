import 'dart:convert';

import 'package:barda/extensions/string_extension.dart';
import 'package:barda/models/post.dart';
import 'package:barda/pages/person.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../services/auth.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage(this.post);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Future editPost(String id, String text, bool audience) async {
    // Get AuthToken
    var token = await Auth.getToken();

    final res = await http.put(
        Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post/$id'),
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

  Future deletePost(String id) async {
    // Get AuthToken
    var token = await Auth.getToken();

    final res = await http.delete(
        Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post/$id'),
        headers: <String, String>{'Authorization': 'Bearer $token'});

    var jsonData = jsonDecode(res.body);
    return jsonData;
  }

  editSheet(BuildContext context, String text, String id, bool is_public) {
    var edited_text = text, edit_public = is_public;
    TextEditingController controller = TextEditingController();

    controller.text = text;

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter mystate) {
            return Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Column(children: [
                      Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 30),
                          child: TextField(
                            controller: controller,
                            onChanged: (value) => edited_text = value,
                            maxLines: 3,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 1),
                                )),
                          )),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Audience:',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 15),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    iconSize: 35,
                                    icon: Icon(
                                      Icons.public,
                                      color: edit_public
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      mystate(() {
                                        edit_public = true;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    iconSize: 35,
                                    icon: Icon(
                                      Icons.group,
                                      color: edit_public
                                          ? Colors.grey
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                    ),
                                    onPressed: () {
                                      mystate(() {
                                        edit_public = false;
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
                            onPressed: () async {
                              var response =
                                  await editPost(id, edited_text, edit_public);

                              if (response['success']) {
                                var p = response['data'];
                                var date = DateTime.fromMillisecondsSinceEpoch(
                                    p['date']);

                                Post post = Post(
                                    id: p['id'],
                                    text: p['text'],
                                    username: p['username'],
                                    public: p['public'],
                                    is_authuser: true,
                                    date: date,
                                    updated: p['updated']);
                                setState(() {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PostPage(post)));
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: RichText(
                                          textAlign: TextAlign.center,
                                          text: const TextSpan(
                                            text: 'Success!',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      ' Your post is now posted.',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8));
                              } else {
                                var statusCode = response['statusCode'];
                                var message = response['message']
                                    .toString()
                                    .toCapitalized();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: 'Error $statusCode.',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: ' $message',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(2000)))),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                'Edit Post',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ))
                    ])));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    var username = widget.post.username,
        text = widget.post.text,
        owned = widget.post.is_authuser,
        id = widget.post.id,
        is_public = widget.post.public,
        date = DateFormat.yMMMMd('en_US').format(widget.post.date),
        time = DateFormat.jm().format(widget.post.date);

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.only(top: 50, left: 1),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(2000)))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new,
                        size: 15, color: Colors.black),
                    label: const Text(
                      'Back',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )),
            const Divider(),
            Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Person(username)));
                      },
                      child: Text(
                        '@$username',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                    if (owned)
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  editSheet(context, text, id, is_public);
                                },
                                icon: const Icon(Icons.edit,
                                    size: 15, color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: IconButton(
                                  color: Colors.white,
                                  onPressed: () async {
                                    var response = await deletePost(id);

                                    if (response['success']) {
                                      Navigator.pop(context);
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: RichText(
                                                textAlign: TextAlign.center,
                                                text: const TextSpan(
                                                  text: 'Success!',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.white),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            ' Your post is now deleted.',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ),
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              padding: const EdgeInsets.all(20),
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8));
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
                                                        text: ' $message',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ),
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              padding: const EdgeInsets.all(20),
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
                                  icon: const Icon(Icons.delete,
                                      size: 15, color: Colors.black)),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    text,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$time • $date',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
            ]),
          ]),
        ));
    ;
  }
}
