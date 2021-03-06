import 'package:barda/pages/create.dart';
import 'package:barda/pages/feed.dart';
import 'package:barda/pages/profile.dart';
import 'package:flutter/material.dart';

// HOME PAGE
// Directly after logging in or opening the app, the user gets directed here.
// This contains the bottom navigation tab and navigation for the main pages: feed, auth user's profile, create

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController pageController;
  int pageIndex = 0; // Starts at feed page

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(
      pageIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        body: PageView(
          children: const <Widget>[Feed(), Create(), Profile()],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
              onTap: onTap,
              iconSize: 30,
              currentIndex: pageIndex,
              backgroundColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Theme.of(context).colorScheme.secondary,
              unselectedItemColor: Colors.white,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_circle_outlined,
                      key: Key('create_btn'),
                    ),
                    activeIcon: Icon(Icons.add_circle),
                    label: 'Add'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_outlined,
                      key: Key('profile_btn'),
                    ),
                    activeIcon: Icon(Icons.person),
                    label: 'User'),
              ]),
        ));
  }
}
