import 'package:barda/services/feed_getter.dart';
import 'package:barda/widgets/post_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/auth.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late Future<List<Post>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = getPosts(null, null, null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _posts,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return CupertinoActivityIndicator();
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: generatepost(context, snapshot.data[index]),
                          );
                        }),
                  ))
                ],
              );
            }
          }),
    );

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Text('Feed'),
    //     generatepost(context, posts[0]),
    //     ElevatedButton(
    //         onPressed: () async {
    //           getPosts(null, '', '');
    //         },
    //         child: Text('Press Me'))
    //   ],
    // );
  }
}
