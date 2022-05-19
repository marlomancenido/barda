import 'package:flutter/material.dart';
import './question.dart';
import './answer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _idx = 0;

  void _answerQ() {
    setState(() {
      if (_idx >= 1) {
        _idx = 0;
      } else {
        _idx += 1;
      }
    });
    // print(_idx);
  }

  List questions = [
    {
      'questionText': 'Whats your favorite animal?',
      'answer': ['Cats', 'Dogs']
    },
    {
      'questionText': 'Whats your favorite color?',
      'answer': ['Pink', 'White']
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My first App'),
        ),
        body: Column(children: [
          Question(questions[_idx]['questionText']),
          ...(questions[_idx]['answer'] as List<String>).map((answer) {
            return Answer(_answerQ, answer);
          }).toList()
        ]),
      ),
    );
  }
}
