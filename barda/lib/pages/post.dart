import 'dart:convert';
import 'package:barda/extensions/string_extension.dart';
import 'package:barda/models/post.dart';
import 'package:barda/pages/person.dart';
import 'package:barda/widgets/comments.dart';
import 'package:barda/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../services/auth.dart';

// POST PAGE
// Generates a page when a post is clicked. Shows everything about the post.
// Also contains functions for removing a post, editing a post and submitting a comment
// Function for deleting a comment is in the comments in the widgets folder

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage(this.post);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // Edit Post
  // Submits edited post to API.
  // Returns response for error/success handling
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

  // Delete Post
  // Deletes a post. Happens when delete is clicked by auth user
  // Returns response for error/success handling
  Future deletePost(String id) async {
    // Get AuthToken
    var token = await Auth.getToken();

    final res = await http.delete(
        Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post/$id'),
        headers: <String, String>{'Authorization': 'Bearer $token'});

    var jsonData = jsonDecode(res.body);
    return jsonData;
  }

  // Submit Comment
  // Submits a comment to API.
  // Retunrs ressponse for error/success handling
  Future submitComment(String text, String id) async {
    // Get AuthToken
    var token = await Auth.getToken();

    final res = await http.post(
        Uri.parse(
            'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/comment/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'text': text,
        }));

    var jsonData = jsonDecode(res.body);
    return jsonData;
  }

  // Edit Sheet
  // Displays bottom modal sheet containing form for editing a post
  // Also displays if success/error when calling editPost
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
                            key: Key('edit_text'),
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
                                    key: Key('edit_pub'),
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
                                    key: Key('edit_priv'),
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
                            key: Key('edit_submit'),
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
                                showSuccess(context, "Post edited.");
                              } else {
                                var statusCode = response['statusCode'];
                                var message = response['message']
                                    .toString()
                                    .toCapitalized();
                                showError(context, statusCode, message);
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

  // Add Comment
  // Displays a bottom modal sheet for adding a comment.
  // Also displays if success/error when calling submitComment
  addComment(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter mystate) {
            return Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(children: [
                      Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 30),
                          child: TextField(
                            key: Key('comment_text'),
                            controller: controller,
                            maxLines: 3,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: 'Enter comment here',
                                hintStyle: TextStyle(color: Colors.grey),
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
                          padding: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            key: Key('comment_submit'),
                            onPressed: () async {
                              var response = await submitComment(
                                  controller.text, widget.post.id);

                              if (response['success']) {
                                setState(() {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          PostPage(widget.post)));
                                });
                                showSuccess(context, "Comment submitted.");
                              } else {
                                var statusCode = response['statusCode'];
                                var message = response['message']
                                    .toString()
                                    .toCapitalized();
                                showError(context, statusCode, message);
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
                                'Submit comment',
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 50, left: 1),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(2000)))),
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
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: IconButton(
                                    key: Key('edit_post'),
                                    color: Colors.white,
                                    onPressed: () {
                                      editSheet(context, text, id, is_public);
                                    },
                                    icon: const Icon(Icons.edit,
                                        size: 15, color: Colors.black)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: IconButton(
                                      key: Key('del_post'),
                                      color: Colors.white,
                                      onPressed: () async {
                                        var response = await deletePost(id);

                                        if (response['success']) {
                                          Navigator.pop(context);
                                          setState(() {});
                                          showSuccess(
                                              context, 'Post is now deleted.');
                                        } else {
                                          var statusCode =
                                              response['statusCode'];
                                          var message = response['message']
                                              .toString()
                                              .toCapitalized();
                                          showError(
                                              context, statusCode, message);
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
                        child: is_public
                            ? Row(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 3),
                                    child: Icon(Icons.public,
                                        size: 13, color: Colors.grey),
                                  ),
                                  Text(
                                    'Public',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                  )
                                ],
                              )
                            : Row(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 3),
                                    child: Icon(Icons.group,
                                        size: 13, color: Colors.grey),
                                  ),
                                  Text(
                                    'Friends',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                  )
                                ],
                              )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            constraints: const BoxConstraints(maxHeight: 300),
                            child: SizedBox(
                                child: Scrollbar(
                                    // thumbVisibility: true,
                                    child: SingleChildScrollView(
                              child: Text(
                                text,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ))))),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$time • $date',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                        ],
                      )),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                ]),
                Comments(id),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      key: Key('add_comment'),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        addComment(context);
                      },
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ]),
        ));
  }
}
