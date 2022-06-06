import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String questionText;

  // ignore: use_key_in_widget_constructors
  const Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      child: Text(questionText,
          style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
    );
  }
}
