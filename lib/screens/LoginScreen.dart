import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/LoginProvider.dart';
import 'HomeScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              foregroundDecoration: BoxDecoration(
                // border: Border.all(color: Colors.white),
                gradient: RadialGradient(colors: [
                  Colors.transparent,
                  Colors.black,
                ], radius: 1.6.spMax, center: Alignment.topCenter),
                // border: Border.all(color: Colors.white)
              ),

              height: 2200.h,

              // width: 1080.w,
              child: Image.asset("assets/crowd.jpg",
                  fit: BoxFit.fitHeight, alignment: Alignment.center,),
            ),
            Positioned(
              top: 400.h,
              left: 100.w,
              width: 1080.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Hey",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 180.sp,
                        fontWeight: FontWeight.w900,
                    letterSpacing: 0),
                  ),
                  // Text(
                  //   "Events",
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 120.sp,
                  //       fontWeight: FontWeight.w900),
                  // ),
                ],
              ),
            ),
            Positioned(
              top: 610.h,
              left: 100.w,
              width: 1080.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "ready for",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 180.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0),
                  ),
                  // Text(
                  //   "Events",
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 120.sp,
                  //       fontWeight: FontWeight.w900),
                  // ),
                ],
              ),
            ),
            Positioned(
              top: 820.h,
              left: 100.w,
              width: 1080.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Today ?",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 180.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0),
                  ),
                  // Text(
                  //   "Events",
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 120.sp,
                  //       fontWeight: FontWeight.w900),
                  // ),
                ],
              ),
            ),
            Positioned(
              top: 1070.h,
              left: 105.w,
              width: 1080.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Let us find you an event for",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0),
                  ),
                  // Text(
                  //   "Events",
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 120.sp,
                  //       fontWeight: FontWeight.w900),
                  // ),
                ],
              ),
            ),
            Positioned(
              top: 1150.h,
              left: 105.w,
              width: 1080.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "your interest",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0),
                  ),
                  // Text(
                  //   "Events",
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 120.sp,
                  //       fontWeight: FontWeight.w900),
                  // ),
                ],
              ),
            ),


            Positioned(
              top: 1925.h,
              width: 1080.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 180.w),
                child: OutlinedButton(
                  onPressed: () async {
                    print("SignIn Pressed");
                    await Provider.of<LoginProvider>(context,
                        listen: false)
                        .loginWithGoogle()
                        .then((value) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen(firebaseAuth: FirebaseAuth.instance,)),
                              (route) => false);
                    });
                  },
                  style: ButtonStyle(
                    // padding:
                    // MaterialStatePropertyAll<EdgeInsetsGeometry>(
                    //     EdgeInsets.symmetric(
                    //         horizontal: 60.w, vertical: 25.h)),
                      shape: MaterialStatePropertyAll<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35))),
                      backgroundColor:
                      MaterialStatePropertyAll<Color>(Color(0xeaf65124)),
                      elevation: MaterialStatePropertyAll<double>(24.r)),
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 50.w, vertical: 45.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image(
                          image: AssetImage("assets/google.png"),
                          height: 80.r,
                        ),
                        SizedBox(
                          width: 40.w,
                        ),
                        Text(
                          "Sign In",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              // fontWeight: FontWeight.w500,
                              fontSize: 60.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
