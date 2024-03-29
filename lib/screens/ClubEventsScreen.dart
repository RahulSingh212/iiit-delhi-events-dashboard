// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iiitd_evnts/models/ClubModel.dart';
import 'package:iiitd_evnts/providers/ClubDetailProvider.dart';
import 'package:provider/provider.dart';

import '../components/GridViewWidget.dart';
import '../providers/NavBarIndexProvider.dart';
import 'NavBarScreen.dart';

class ClubEventsScreen extends StatefulWidget {
  ClubEventsScreen({super.key, required this.clubDetails});

  ClubModel clubDetails;
  @override
  State<ClubEventsScreen> createState() => _ClubEventsScreenState();
}

class _ClubEventsScreenState extends State<ClubEventsScreen> {

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    await Provider.of<ClubDetailProvider>(context, listen: false)
        .fetchClubEventDetails(widget.clubDetails)
        .then((value) {
      setState(() {
        widget.clubDetails = value;
        isLoading = false;
      });
    });
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
          widget.clubDetails.clubName,
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
          child: SizedBox(
            height: 2000.h,
            child: isLoading? const Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow,
                )
            ) :SingleChildScrollView(
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
                      // padding:EdgeInsets.only(top: 60.h, left: 40.w, right: 40.w),
                      width: double.infinity,
                      height: 700.h,
                      decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   image: AssetImage("assets/Illstration.png"),
                        //   fit: BoxFit.fill,
                        // ),
                          borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(image: NetworkImage(widget.clubDetails.clubLogoUrl), fit: BoxFit.cover)
                        // color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      height: 100.h,
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
                              widget.clubDetails.clubDescription,
                              style: TextStyle(
                                  fontSize: 40.sp, color: Colors.black),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    widget.clubDetails.liveEventList.isEmpty && widget.clubDetails.upcomingEventList.isEmpty ? Container(
                  padding: EdgeInsets.symmetric(vertical: 200.h, horizontal: 20.w),
                  child: Center(child:  Text(
                      "No Live or Upcoming Events for ${widget.clubDetails.clubName}",
                      style: TextStyle(

                          fontSize: 70.sp, color: Colors.black
                      ),
                    textAlign: TextAlign.center,
                    ),),):
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.clubDetails.liveEventList.isEmpty ? Container():
                        Container(
                          margin: EdgeInsets.only(
                            top: 58.h,
                          ),
                          child: Text(
                            "Live Events",
                            style: TextStyle(
                                fontSize: 70.sp, color: Colors.black),
                          ),
                        ),
                        GridViewWidget(eventList: widget.clubDetails.liveEventList, isSubEvent: false,),
                        widget.clubDetails.upcomingEventList.isEmpty ? Container():
                        Container(
                          margin: EdgeInsets.only(
                            top: 58.h,
                          ),
                          child: Text(
                            "Upcoming Events",
                            style: TextStyle(
                                fontSize: 70.sp, color: Colors.black),
                          ),
                        ),
                        GridViewWidget(eventList: widget.clubDetails.upcomingEventList, isSubEvent: false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),

      // body: SafeArea(
      //     child: Container(
      //       height: 2000.h,
      //       child: SingleChildScrollView(
      //         scrollDirection: Axis.vertical,
      //         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      //         physics: BouncingScrollPhysics(),
      //         child: Container(
      //           padding: EdgeInsets.only(top: 20.h, left: 54.w, right: 54.w),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             mainAxisSize: MainAxisSize.max,
      //             children: [
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 mainAxisSize: MainAxisSize.max,
      //                 children: [
      //                   Container(
      //                     margin: EdgeInsets.only(
      //                       top: 58.h,
      //                     ),
      //                     child: Text(
      //                       "Live Events",
      //                       style: TextStyle(
      //                           fontSize: 70.sp, color: Colors.white),
      //                     ),
      //                   ),
      //                   Container(
      //                     // padding: EdgeInsets.only(top: 58.h),
      //                     margin: EdgeInsets.only(top: 58.h),
      //                     alignment: Alignment.topCenter,
      //                     // decoration: BoxDecoration(
      //                     //   border: Border.all()
      //                     // ),
      //                     height: 1300.h,
      //                     child: GridView.builder(
      //                       physics: NeverScrollableScrollPhysics(),
      //                       gridDelegate:
      //                       SliverGridDelegateWithFixedCrossAxisCount(
      //                           crossAxisCount: 2,
      //                           crossAxisSpacing: 30.w,
      //                           mainAxisSpacing: 40.h),
      //                       itemCount: 10,
      //                       clipBehavior: Clip.antiAliasWithSaveLayer,
      //                       itemBuilder: (context, position) {
      //                         return InkWell(
      //                           onTap: (){
      //                             // Navigator.push(
      //                             //     context,
      //                             //     MaterialPageRoute(builder: (_) => EventScreen()));
      //                           },
      //                           child: Container(
      //                             height: 100.h,
      //                             width: 250.w,
      //                             decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(15),
      //                                 color: Colors.white),
      //                             child: Center(
      //                               child: Text(Provider.of<ClubDetailProvider>(context, listen: false)
      //                                   .clubDetails.clubName),
      //                             ),
      //                           ),
      //                         );
      //                       },
      //                     ),
      //                   ),
      //                   Container(
      //                     margin: EdgeInsets.only(
      //                       top: 58.h,
      //                     ),
      //                     child: Text(
      //                       "Upcoming Events",
      //                       style: TextStyle(
      //                           fontSize: 70.sp, color: Colors.white),
      //                     ),
      //                   ),
      //                   Container(
      //                     // padding: EdgeInsets.only(top: 58.h),
      //                     margin: EdgeInsets.only(top: 58.h),
      //                     alignment: Alignment.topCenter,
      //                     // decoration: BoxDecoration(
      //                     //   border: Border.all()
      //                     // ),
      //                     height: 1300.h,
      //                     child: GridView.builder(
      //                       physics: NeverScrollableScrollPhysics(),
      //                       gridDelegate:
      //                       SliverGridDelegateWithFixedCrossAxisCount(
      //                           crossAxisCount: 2,
      //                           crossAxisSpacing: 30.w,
      //                           mainAxisSpacing: 40.h),
      //                       itemCount: 10,
      //                       clipBehavior: Clip.antiAliasWithSaveLayer,
      //                       itemBuilder: (context, position) {
      //                         return InkWell(
      //                           onTap: (){
      //                             // Navigator.push(
      //                             //     context,
      //                             //     MaterialPageRoute(builder: (_) => EventScreen()));
      //                           },
      //                           child: Container(
      //                             height: 100.h,
      //                             width: 250.w,
      //                             decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(15),
      //                                 color: Colors.white),
      //                             child: Center(
      //                               child: Text("Event"),
      //                             ),
      //                           ),
      //                         );
      //                       },
      //                     ),
      //                   ),
      //                   Container(
      //                     margin: EdgeInsets.only(
      //                       top: 58.h,
      //                     ),
      //                     child: Text(
      //                       "Past Events",
      //                       style: TextStyle(
      //                           fontSize: 70.sp, color: Colors.white),
      //                     ),
      //                   ),
      //                   Container(
      //                     // padding: EdgeInsets.only(top: 58.h),
      //                     margin: EdgeInsets.only(top: 58.h),
      //                     alignment: Alignment.topCenter,
      //                     // decoration: BoxDecoration(
      //                     //   border: Border.all()
      //                     // ),
      //                     height: 1300.h,
      //                     child: GridView.builder(
      //                       physics: NeverScrollableScrollPhysics(),
      //                       gridDelegate:
      //                       SliverGridDelegateWithFixedCrossAxisCount(
      //                           crossAxisCount: 2,
      //                           crossAxisSpacing: 30.w,
      //                           mainAxisSpacing: 40.h),
      //                       itemCount: 10,
      //                       clipBehavior: Clip.antiAliasWithSaveLayer,
      //                       itemBuilder: (context, position) {
      //                         return InkWell(
      //                           onTap: (){
      //                             // Navigator.push(
      //                             //     context,
      //                             //     MaterialPageRoute(builder: (_) => EventScreen()));
      //                           },
      //                           child: Container(
      //                             height: 100.h,
      //                             width: 250.w,
      //                             decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(15),
      //                                 color: Colors.white),
      //                             child: Center(
      //                               child: Text("Event"),
      //                             ),
      //                           ),
      //                         );
      //                       },
      //                     ),
      //                   ),
      //                   // Expanded(
      //                   //   // padding: EdgeInsets.only(top: 58.h),
      //                   //   margin: EdgeInsets.only(
      //                   //     top: 25.h,
      //                   //   ),
      //                   //   alignment: Alignment.center,
      //                   //   // decoration: BoxDecoration(
      //                   //   //   border: Border.all()
      //                   //   // ),
      //                   //   // height: 300.h,
      //                   //   child:
      //                   //   // child: ListView.builder(
      //                   //   //   // itemCount: themes.getThemesList().length,
      //                   //   //   itemCount: 10,
      //                   //   //   scrollDirection: Axis.horizontal,
      //                   //   //   physics: BouncingScrollPhysics(),
      //                   //   //   padding: EdgeInsets.symmetric(
      //                   //   //     vertical: 23.h,
      //                   //   //     horizontal: 21.w,
      //                   //   //   ),
      //                   //   //   itemBuilder: (context, position) {
      //                   //   //     return Container(
      //                   //   //       // height: 50.h,
      //                   //   //       width: 250.w,
      //                   //   //       color: Colors.red,
      //                   //   //       child: Card(
      //                   //   //         elevation: 8,
      //                   //   //         shadowColor: Colors.white,
      //                   //   //         child: Center(
      //                   //   //           child: Text("Wassup"),
      //                   //   //         ),
      //                   //   //       ),
      //                   //   //     );
      //                   //   //   },
      //                   //   // ),
      //                   // ),
      //                   // Container(
      //                   //   margin: EdgeInsets.only(
      //                   //     top: 58.h,
      //                   //   ),
      //                   //   child: Text(
      //                   //     "Schedule",
      //                   //     style: TextStyle(
      //                   //         fontSize: 70.sp, color: Colors.white),
      //                   //   ),
      //                   // ),
      //                   // Container(
      //                   //   // padding: EdgeInsets.only(top: 58.h),
      //                   //   margin: EdgeInsets.only(top: 58.h),
      //                   //   alignment: Alignment.topCenter,
      //                   //   // decoration: BoxDecoration(
      //                   //   //   border: Border.all()
      //                   //   // ),
      //                   //   // height: height*1.5,
      //                   //   child: ListView.builder(
      //                   //     itemCount: eventUtil.length,
      //                   //     // scrollDirection: Axis.horizontal,
      //                   //     shrinkWrap: true,
      //                   //     physics: NeverScrollableScrollPhysics(),
      //                   //     padding: EdgeInsets.only(top: 23.h),
      //                   //     itemBuilder: (context, position) {
      //                   //       return EventCard(
      //                   //         eventDetails: eventUtil[position],
      //                   //       );
      //                   //     },
      //                   //   ),
      //                   // ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     )),
      // bottomNavigationBar: SalomonBottomBar(
      //   currentIndex: Provider.of<NavBarIndexProvider>(context, listen: false)
      //       .pageIndex,
      //   onTap: (index) => setState((){
      //     Provider.of<NavBarIndexProvider>(context, listen: false)
      //         .setPageIndex(index);
      //     Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(builder: (_) => NavBarScreen()),
      //             (route) => false);
      //   }),
      //   // backgroundColor: Colors.red,
      //   // curve: Cur,
      //   items: [
      //     SalomonBottomBarItem(
      //         icon: Icon(Icons.home),
      //         title: Text("Home"),
      //         selectedColor: Colors.yellow,
      //         unselectedColor: Colors.white
      //     ),
      //
      //     SalomonBottomBarItem(
      //         icon: Icon(Icons.person),
      //         title: Text("Clubs"),
      //         selectedColor: Colors.yellow,
      //         unselectedColor: Colors.white
      //     ),
      //   ],
      // ),
    );
  }
}
