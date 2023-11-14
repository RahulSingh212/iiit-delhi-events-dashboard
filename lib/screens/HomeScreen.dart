// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iiitd_evnts/providers/EventDetailsProvider.dart';
import 'package:provider/provider.dart';

import '../components/GridViewWidget.dart';
import 'ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.firebaseAuth});

  FirebaseAuth firebaseAuth;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // User? currUser = FirebaseAuth.instance.currentUser;

  bool isLoading = true;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    await Provider.of<EventDetailsProvider>(context, listen: false)
        .fetchGlobalEventDetails().then((value) async {
      setState(() {
        isLoading = false;
        print("Loading Completed...");
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black45,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 60.sp,
          ),
          textAlign: TextAlign.center,
        ),
        iconTheme: IconThemeData(
          color: Colors.blue,
          size: 80.r,
        ),
        actions: [
          // Container(
          //   padding: EdgeInsets.only(top: 15.h, bottom: 25.h),
          //   child: Center(
          //     child: Image.asset(
          //       "assets/iiitD-Logo.jpg",
          //       fit: BoxFit.contain,
          //     ),
          //   ),
          // ),
          Container(
            padding: EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () async {
                // if (Provider.of<UserDetailsProvider>(context, listen: false)
                //     .userType ==
                //     "Guest") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
                // } else {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => FacultyProfileScreen(),
                //     ),
                //   );
                // }
              },
              icon: Icon(
                Icons.person,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(top: 20.h, left: 54.w, right: 54.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                    EdgeInsets.only(top: 60.h, left: 40.w, right: 40.w, bottom: 60.h),
                    width: double.infinity,
                    // height: 380.h,
                    decoration: BoxDecoration(
                      // image: DecorationImage(
                      //   image: AssetImage("assets/Illstration.png"),
                      //   fit: BoxFit.fill,
                      // ),
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF424949)
                      // color: Colors.red,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Hello,",
                          style: TextStyle(
                            fontSize: 70.sp,
                            color: Colors.white,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.firebaseAuth.currentUser?.displayName ?? 'Guest',
                            style: TextStyle(
                                fontSize: 80.sp,
                                color: Colors.yellow,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 58.h,
                        ),
                        child: Text(
                          "Live Events",
                          style: TextStyle(
                              fontSize: 70.sp, color: Colors.white),
                        ),
                      ),
                      GridViewWidget(eventList: Provider.of<EventDetailsProvider>(context,listen: false).globalLiveEventList, isSubEvent: false,),
                      Container(
                        margin: EdgeInsets.only(
                          top: 58.h,
                        ),
                        child: Text(
                          "Upcoming Events",
                          style: TextStyle(
                              fontSize: 70.sp, color: Colors.white),
                        ),
                      ),
                      GridViewWidget(eventList: Provider.of<EventDetailsProvider>(context,listen: false).globalUpcomingEventList, isSubEvent: false),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
