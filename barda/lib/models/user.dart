import 'package:barda/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth.dart';

// Makes a User Class
// Unfortunately, this didn't get used in the end to avoid overcomplicating the app
class User {
  // String username, firstName, lastName;
  // User(this.username, this.firstName, this.lastName);
  String username;
  User(this.username);
}

// Get User Posts
// Retrieves auth user's posts
Future<List<Post>> getUserPosts() async {
  // Retrieve Token and Username
  final token = await Auth.getToken(), username = await Auth.getUsername();

  List<Post> posts = [];
  final uri = Uri.https('cmsc-23-2022-bfv6gozoca-as.a.run.app', '/api/post');
  final res = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
  );

  var jsonData = jsonDecode(res.body);

  for (var p in jsonData['data']) {
    var date = DateTime.fromMillisecondsSinceEpoch(p['date']);
    var post = Post(
        id: p['id'],
        text: p['text'],
        username: p['username'],
        public: p['public'],
        is_authuser: true,
        date: date,
        updated: p['updated']);

    if (p['username'] == username) {
      posts.add(post);
    }
  }

  return posts;
}

// Get Number of Followers
// This returns how many friends the auth user has
Future<int> getNoFollowers() async {
  var friends = await getFriends();
  return friends.length;
}

// Get Auth User Data
// This retrieves all the needed data for the user's profile page (Name, Username, number of followers/friends)
Future getAuthUserData() async {
  final friends = await getFriends();
  final count = friends.length;
  final username = await Auth.getUsername();

  // Retrieve Token
  final token = await Auth.getToken();
  final uri =
      Uri.https('cmsc-23-2022-bfv6gozoca-as.a.run.app', '/api/user/$username');
  final res = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
  );

  var jsonData = jsonDecode(res.body);

  return {
    'username': username,
    'followers_count': count,
    'firstName': jsonData['data']['firstName'],
    'lastName': jsonData['data']['lastName']
  };
}

// isFriends()
// Checks if a user is friends with the auth user
Future isFriends(String username) async {
  final friends = await getFriends();
  return friends.contains(username);
}

// Get Friends
// Returns a list of all the friends of the auth user
Future<List<String>> getFriends() async {
  List<String> friends = [];

  // Retrieve Token
  final token = await Auth.getToken();

  // Query
  Map<String, dynamic> query = {'friends': 'true'};

  final uri =
      Uri.https('cmsc-23-2022-bfv6gozoca-as.a.run.app', '/api/user', query);
  final res = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
  );

  var jsonData = jsonDecode(res.body);

  for (var u in jsonData['data']) {
    friends.add(u['username']);
  }

  return friends;
}

// Get User Data
// Gets the data needed to generate a user profile page (non-auth user)
Future getUserData(String username) async {
  final auth_user = await Auth.getUsername();
  final friends = await getFriends();

  // 0 - Not Friends, 1 - Friends, 2 - isAuthUser
  int friend_stat = 0;

  if (friends.contains(username)) {
    friend_stat = 1;
  } else if (auth_user == username) {
    friend_stat = 2;
  }

  // Retrieve Token
  final token = await Auth.getToken();
  final uri =
      Uri.https('cmsc-23-2022-bfv6gozoca-as.a.run.app', '/api/user/$username');
  final res = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
  );

  var jsonData = jsonDecode(res.body);

  return {
    'username': username,
    'firstName': jsonData['data']['firstName'],
    'lastName': jsonData['data']['lastName'],
    'friendStat': friend_stat
  };
}
