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
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.white12,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontSize: 60.sp,
          ),
          textAlign: TextAlign.center,
        ),
        iconTheme: IconThemeData(
          color: Color(0xeaf65124),
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
              padding: EdgeInsets.only(top: 100.h, left: 54.w, right: 54.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                    EdgeInsets.only(top: 60.h, left: 40.w, right: 40.w, bottom: 80.h),
                    width: double.infinity,
                    // height: 380.h,
                    decoration: BoxDecoration(
                      // image: DecorationImage(
                      //   image: AssetImage("assets/Illstration.png"),
                      //   fit: BoxFit.fill,
                      // ),
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xeaf65124),
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
                  isLoading? Padding(
                    padding: EdgeInsets.symmetric(vertical: 500.h),
                    child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.yellow,
                        )
                    ),
                  ): Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 80.h,
                        ),
                        child: Text(
                          "Live Events",
                          style: TextStyle(
                              fontSize: 70.sp, color: Colors.black87),
                        ),
                      ),
                      Provider.of<EventDetailsProvider>(context,listen: false).globalLiveEventList.isEmpty? Container(
                        padding: EdgeInsets.symmetric(vertical: 100.h, horizontal: 20.w),
                        child: Center(child:  Text(
                          "No Currently Active Events :(",
                          style: TextStyle(
                              fontSize: 50.sp, color: Colors.black87
                          ),
                          textAlign: TextAlign.center,
                        ),),):
                      GridViewWidget(eventList: Provider.of<EventDetailsProvider>(context,listen: false).globalLiveEventList, isSubEvent: false,),
                      Container(
                        margin: EdgeInsets.only(
                          top: 58.h,
                        ),
                        child: Text(
                          "Upcoming Events",
                          style: TextStyle(
                              fontSize: 70.sp, color: Colors.black87),
                        ),
                      ),
                      Provider.of<EventDetailsProvider>(context,listen: false).globalUpcomingEventList.isEmpty? Container(
                        padding: EdgeInsets.symmetric(vertical: 100.h, horizontal: 20.w),
                        child: Center(child:  Text(
                          "No Currently Active Events :(",
                          style: TextStyle(
                              fontSize: 50.sp, color: Colors.black87
                          ),
                          textAlign: TextAlign.center,
                        ),),):
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
