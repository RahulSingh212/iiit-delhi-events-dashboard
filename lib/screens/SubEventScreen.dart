// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iiitd_evnts/models/EventModel.dart';
import 'package:iiitd_evnts/screens/NavBarScreen.dart';
import 'package:provider/provider.dart';

import '../components/EventInformationCard.dart';
import '../providers/NavBarIndexProvider.dart';

class SubEventScreen extends StatefulWidget {
  SubEventScreen({super.key, required this.eventDetails});

  EventModel eventDetails;
  @override
  State<SubEventScreen> createState() => _SubEventScreenState();
}

class _SubEventScreenState extends State<SubEventScreen> with TickerProviderStateMixin{

  late TabController tabController;
  late TextEditingController chatBarController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.eventDetails.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
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
        child: Column(
          children: [
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 60.h),
                  padding: EdgeInsets.only(bottom: 80.h),
                  // color: Colors.pink,
                  child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                          padding:
                          EdgeInsets.only(top: 20.h, left: 54.w, right: 54.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                // padding:EdgeInsets.only(top: 60.h, left: 40.w, right: 40.w),
                                width: double.infinity,
                                height: 700.h,
                                decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //   image: AssetImage("assets/Illstration.png"),
                                  //   fit: BoxFit.fill,
                                  // ),
                                  borderRadius: BorderRadius.circular(30),
                                  // border: Border.all(color: Colors.black, width: 2.sp),
                                  // color: Colors.black45
                                  image: DecorationImage(image: NetworkImage(
                                    widget.eventDetails.logoUrl,
                                  ),
                                      fit: BoxFit.cover),
                                  // color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                height: 100.h,
                              ),
                              Container(
                                // padding: EdgeInsets.only(top: 58.h),
                                // margin: EdgeInsets.only(top: 58.h),
                                alignment: Alignment.topCenter,
                                // decoration: BoxDecoration(
                                //   border: Border.all()
                                // ),
                                height: 350.h,
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 30.w,
                                      mainAxisSpacing: 40.h),
                                  itemCount: 3,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  itemBuilder: (context, position) {
                                    return EventInformationCard(
                                      position: position,
                                      eventDetails: widget.eventDetails,
                                    );
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 58.h,
                                ),
                                child: Text(
                                  "Description",
                                  style: TextStyle(
                                      fontSize: 70.sp, color: Colors.black),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 58.h,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.notes,
                                      color: Colors.black,
                                      size: 100.sp,
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.eventDetails.description*10,
                                        style: TextStyle(
                                            fontSize: 40.sp, color: Colors.black),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ),
                )
          ],
        ),
      ),
    );
  }
}
