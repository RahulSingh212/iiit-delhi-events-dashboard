import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iiitd_evnts/screens/ClubScreen.dart';
import 'package:iiitd_evnts/screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sweet_nav_bar/sweet_nav_bar.dart';

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
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: IndexedStack(
        index:
        Provider.of<NavBarIndexProvider>(context, listen: false).pageIndex,
        // children: const [HomeScreen(), VaultScreen()],
        children: [HomeScreen(firebaseAuth: FirebaseAuth.instance,), ClubScreen(firebaseAuth: FirebaseAuth.instance,)],
      ),
      // body: PageView(
      //   // physics: BouncingScrollPhysics(),
      //   // pageSnapping: false,
      //   controller: pageController,
      //   onPageChanged: (index) {
      //     setState(() {
      //       Provider.of<NavBarIndexProvider>(context, listen: false)
      //           .setPageIndex(index);
      //     });
      //   },
      //   // physics: BouncingScrollPhysics(),
      //   // pageSnapping: false,
      //   children: [HomeScreen(firebaseAuth: FirebaseAuth.instance,), ClubScreen(firebaseAuth: FirebaseAuth.instance,)],
      // ),
      // bottomNavigationBar: SalomonBottomBar(
      //   currentIndex: Provider.of<NavBarIndexProvider>(context, listen: false)
      //       .pageIndex,
      //   onTap: (index) => setState((){
      //     Provider.of<NavBarIndexProvider>(context, listen: false)
      //         .setPageIndex(index);
      //     pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
      //   }),
      //   items: [
      //     SalomonBottomBarItem(
      //       icon: Icon(Icons.home),
      //       title: Text("Home"),
      //       selectedColor: Colors.yellow,
      //       unselectedColor: Colors.white
      //     ),
      //     SalomonBottomBarItem(
      //       icon: Icon(Icons.person),
      //       title: Text("Clubs"),
      //         selectedColor: Colors.yellow,
      //         unselectedColor: Colors.white
      //     ),
      //   ],
      // ),
      bottomNavigationBar: SweetNavBar(
        // paddingGradientColor: const LinearGradient(colors: [
        //   Color.fromARGB(255, 72, 3, 80),
        //   Color.fromARGB(255, 72, 3, 80)
        // ]),
        padding: EdgeInsets.only(left: 120.w, right: 120.w, bottom: 50.h),
        currentIndex: Provider.of<NavBarIndexProvider>(context, listen: false).pageIndex,
        paddingBackgroundColor: Colors.transparent,
        backgroundColor: Color(0xeaf65124),
        showSelectedLabels: true,
        height: 180.h,
        borderRadius: 100.sp,
        items: [
          SweetNavBarItem(
              sweetIcon: Icon(Icons.home_filled, color: Colors.white), sweetLabel: 'Home', isGradiant: false),
          SweetNavBarItem(
              sweetIcon: Icon(Icons.account_balance, color: Colors.white,), sweetLabel: 'Club', isGradiant: false),
        ],
        onTap: (index) {
          setState(() {
                Provider.of<NavBarIndexProvider>(context, listen: false)
                    .setPageIndex(index);
          });
        },
      ),
    );
  }
}
