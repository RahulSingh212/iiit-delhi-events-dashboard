import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/NavBarIndexProvider.dart';
import 'LoginScreen.dart';
import 'NavBarScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  User? currUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
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
                Provider.of<NavBarIndexProvider>(context, listen: false)
                    .setPageIndex(0);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => NavBarScreen()), (route) => false);
                // } else {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => FacultyProfileScreen(),
                //     ),
                //   );
                // }
              },
              icon: Icon(
                Icons.home,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Container(
            height: 2000.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Icon(
                        CupertinoIcons.back,
                        size: 100.r,
                      ),
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                    ),
                    // OutlinedButton(
                    //   onPressed: () {
                    //     print("LogOut Pressed");
                    //   },
                    //   style: ButtonStyle(
                    //       padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                    //           EdgeInsets.symmetric(
                    //               horizontal: 45.w, vertical: 25.h)),
                    //       shape: MaterialStatePropertyAll<OutlinedBorder>(
                    //           RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(20)))),
                    //   child: Container(
                    //     child: Text(
                    //       "${"LogOut"}",
                    //       textAlign: TextAlign.center,
                    //
                    //       style: TextStyle(color: Colors.black,fontSize: 45.sp),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 100.h,top: 40.h),
                  child: Center(
                    child: CircleAvatar(
                      radius: 240.r,
                      backgroundColor: Colors.yellow,
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(
                            currUser?.photoURL as String),
                        radius: 225.r,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(padding: EdgeInsets.only(left: 60.w,top: 50.h,bottom: 20.h,right: 60.w),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,fontFamily: 'JosefinSan-Light',
                          fontWeight: FontWeight.w900),
                      controller: TextEditingController(text: currUser?.displayName),
                      enabled: false,
                      onChanged: (value) => {
                      },
                      decoration: InputDecoration(
                        labelText: "Name",
                        // labelStyle: TextStyle(fontSize: 40.sp),
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white54,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelStyle: TextStyle(color: Colors.white,fontFamily: 'JosefinSan',
                            fontWeight: FontWeight.w900 ,fontSize: 60.sp),
                      ),
                      onTap: (){
                        print("Name : ${currUser?.displayName}");
                      },
                    ),

                  ),
                ),
                Center(
                  child: Padding(padding: EdgeInsets.only(left: 60.w,top: 50.h,bottom: 20.h,right: 60.w),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: TextEditingController(text: currUser?.email),
                      enabled: false,
                      onChanged: (value) => {
                      },
                      style: TextStyle(color: Colors.white,fontFamily: 'JosefinSan-Light',
                          fontWeight: FontWeight.w900),
                      decoration: InputDecoration(
                        labelText: "Email",
                        // labelStyle: TextStyle(fontSize: 40.sp),
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white54,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelStyle: TextStyle(color: Colors.white,fontFamily: 'JosefinSan',
                            fontWeight: FontWeight.w900 ,fontSize: 60.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 100.h,),
                Center(child: OutlinedButton(
                  onPressed: () async {
                    print("LogOut Pressed");
                    // await Provider.of<LoginProvider>(context,listen: false).logOut();
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LoginPage()), (route) => false);
                    });

                    // setState(() {
                    //
                    // });
                  },
                  style: ButtonStyle(
                      padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              horizontal: 45.w, vertical: 25.h)),
                      shape: MaterialStatePropertyAll<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)))),
                  child: Container(
                    child: Text(
                      "Logout",
                      textAlign: TextAlign.center,

                      style: TextStyle(color: Colors.white,fontFamily: 'JosefinSan-Light',
                          fontWeight: FontWeight.w900 ,fontSize: 45.sp),
                    ),
                  ),
                ),)
              ],
            ),

          )),
    );
  }
}
