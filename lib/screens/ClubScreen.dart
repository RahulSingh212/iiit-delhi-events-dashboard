// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iiitd_evnts/components/ClubCard.dart';
import 'package:iiitd_evnts/providers/ClubDetailProvider.dart';
import 'package:provider/provider.dart';

import 'ProfileScreen.dart';

class ClubScreen extends StatefulWidget {
  ClubScreen({super.key, required this.firebaseAuth});

  FirebaseAuth firebaseAuth;

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {

  late var currUser = widget.firebaseAuth.currentUser;

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    await Provider.of<ClubDetailProvider>(context, listen: false)
        .fetchGlobalClubList().then((value) async {
      setState(() {
        isLoading = false;
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
          "Clubs",
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
          child: Container(
            height: 2000.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.only(top: 20.h, left: 54.w, right: 54.w),
                child: Container(
                  // padding: EdgeInsets.only(top: 58.h),
                  // margin: EdgeInsets.only(top: 58.h),
                  alignment: Alignment.topCenter,
                  // decoration: BoxDecoration(
                  //   border: Border.all()
                  // ),
                  // height: height*1.5,
                  child: ListView.builder(
                    itemCount: Provider.of<ClubDetailProvider>(context, listen: false).globalClubList.length,
                    // scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // padding: EdgeInsets.only(top: 23.h),
                    itemBuilder: (context, position) {
                      return ClubCard(clubDetails: Provider.of<ClubDetailProvider>(context, listen: false).globalClubList[position],);
                    },
                  ),
                ),

              ),
            ),
          )),
    );
  }
}
