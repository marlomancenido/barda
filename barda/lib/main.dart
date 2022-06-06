import 'package:barda/pages/home.dart';
import 'package:barda/pages/splash.dart';
import 'package:barda/services/auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MAIN FILE
// Sets the theme of the app and colorscheme/fontfamily for easy accessing in pages

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BARDA Social',
      theme: ThemeData(
          fontFamily: 'Sharp Sans',
          primaryColor: const Color.fromRGBO(44, 19, 221, 1),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: const Color.fromRGBO(255, 196, 221, 1),
              primary: const Color.fromRGBO(44, 19, 221, 1),
              tertiary: const Color.fromRGBO(28, 26, 27, 1))),
      home: FutureBuilder(
        future: Auth.getToken(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return const Home();
          } else {
            return const Splash();
          }
        },
      ),
      routes: {'/home': (_) => const Home(), '/splash': (_) => const Splash()},
    );
  }
}
