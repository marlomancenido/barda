import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Splash
// Contains the splash screen or the landing page for the app. Here, the user logs in on registers

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isAuth = false;

  buildAuthScreen() {
    return const Text('auth');
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
        body: Container(
            // alignment: Alignment.center,
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.tertiary),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                      child: RichText(
                        text: TextSpan(
                          text: 'oras na para\nmakipag-',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 30,
                              color: Colors.white),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'barda',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 35,
                                    color: Theme.of(context).primaryColor)),
                            TextSpan(text: 'han!'),
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                    child: Row(
                      children: [
                        OutlinedButton(
                            onPressed: null,
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                              child: Text(
                                'sign in',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2000))),
                              side: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextButton(
                              onPressed: null,
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Text(
                                  'create an account',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2000))))),
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
                    child: Text(
                      'By signing up, you agree to all our conditions.',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, top: 300, bottom: 50),
                    child: Text(
                      'Made by: Marlo Fiel Mancenido',
                      style: TextStyle(
                          fontSize: 8,
                          color: Theme.of(context).colorScheme.secondary),
                      textAlign: TextAlign.left,
                    ),
                  )
                ])));
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
