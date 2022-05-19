import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const DataFromAPI(),
    );
  }
}

class DataFromAPI extends StatefulWidget {
  const DataFromAPI({Key? key}) : super(key: key);

  @override
  State<DataFromAPI> createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  // Async Function -> Getting Data
  Future getTodoData() async {
    var res =
        await http.get(Uri.https('jsonplaceholder.typicode.com', 'todos'));
    var jsonData = jsonDecode(res.body);
    List<Todo> todos = [];

    // Makes todos and appends to list "todos"
    for (var t in jsonData) {
      Todo todo = Todo(t['userId'], t['id'], t['title'], t['completed']);
      todos.add(todo);
    }
    return todos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Sample Networking')),
        body: Container(
            child: Card(
                child: FutureBuilder(
          future: getTodoData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: Text("Loading ..."));
            } else {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Checkbox(
                        value: snapshot.data[index].completed,
                        onChanged: null,
                      ),
                      title: Text(snapshot.data[index].title));
                },
              );
            }
          },
        ))));
  }
}

class Todo {
  final int userId, id;
  final String title;
  final bool completed;

  Todo(this.userId, this.id, this.title, this.completed);
}
