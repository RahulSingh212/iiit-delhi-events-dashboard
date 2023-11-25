import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iiitd_evnts/screens/ClubScreen.dart';
import 'package:iiitd_evnts/screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../providers/NavBarIndexProvider.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {

  User? currUser = FirebaseAuth.instance.currentUser;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black45,
      extendBodyBehindAppBar: true,
      // body: IndexedStack(
      //   index:
      //   Provider.of<NavBarIndexProvider>(context, listen: false).pageIndex,
      //   // children: const [HomeScreen(), VaultScreen()],
      //   children: const [HomeScreen(),ClubScreen()],
      // ),
      body: PageView(
        // physics: BouncingScrollPhysics(),
        // pageSnapping: false,
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            Provider.of<NavBarIndexProvider>(context, listen: false)
                .setPageIndex(index);
          });
        },
        // physics: BouncingScrollPhysics(),
        // pageSnapping: false,
        children: [HomeScreen(firebaseAuth: FirebaseAuth.instance,), ClubScreen(firebaseAuth: FirebaseAuth.instance,)],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: Provider.of<NavBarIndexProvider>(context, listen: false)
            .pageIndex,
        onTap: (index) => setState((){
          Provider.of<NavBarIndexProvider>(context, listen: false)
              .setPageIndex(index);
          pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
        }),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.yellow,
            unselectedColor: Colors.white
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Clubs"),
              selectedColor: Colors.yellow,
              unselectedColor: Colors.white
          ),
        ],
      ),
    );
  }
}
