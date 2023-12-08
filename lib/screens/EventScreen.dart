// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:iiitd_evnts/components/GridViewWidget.dart';
import 'package:iiitd_evnts/models/EventDiscussionModel.dart';
import 'package:iiitd_evnts/models/EventModel.dart';
import 'package:iiitd_evnts/models/QRModel.dart';
import 'package:iiitd_evnts/providers/CalendarApiProvider.dart';
import 'package:iiitd_evnts/providers/UserDetailsProvider.dart';
import 'package:iiitd_evnts/screens/NavBarScreen.dart';
import 'package:provider/provider.dart';

import '../components/EventInformationCard.dart';
import '../providers/EventDetailsProvider.dart';
import '../providers/NavBarIndexProvider.dart';

class EventScreen extends StatefulWidget {
  EventScreen({super.key, required this.eventDetails});

  late EventModel eventDetails;
  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  late TextEditingController chatBarController = TextEditingController();

  bool isLoading = false;
  var currUser = FirebaseAuth.instance.currentUser;

  List<EventDiscussionMessageModel> chats = [];

  bool registered = false;

  loadDetails() async {
    await Provider.of<EventDetailsProvider>(context, listen: false).fetchEventDiscussions(widget.eventDetails.eventId).then((value) async {
      setState(() {
        print("Chats Loaded...");
        chats = value;
      });
    });
    await Provider.of<EventDetailsProvider>(context, listen: false).checkUserRegistration(widget.eventDetails.eventId, currUser!.uid.toString()).then((value) async {
      setState(() {
        print("Chats Loaded...");
        registered = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    loadDetails();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    loadDetails();
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
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.eventDetails.name,
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
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => NavBarScreen()),
                    (route) => false);
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
            TabBar(
              tabs: <Widget>[
                Tab(
                  icon: const Icon(Icons.event),
                  iconMargin: EdgeInsets.only(bottom: 20.h),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Event ",
                      style: TextStyle(
                          fontSize: 32.sp,
                          fontFamily: 'BrunoAceSC',
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                Tab(
                  icon: const Icon(Icons.credit_card_sharp),
                  iconMargin: EdgeInsets.only(bottom: 20.h),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Discussion ",
                      style: TextStyle(
                          fontSize: 32.sp,
                          fontFamily: 'BrunoAceSC',
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              controller: tabController,
              indicatorColor: Colors.yellow,
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(top: 60.h),
              padding: EdgeInsets.only(bottom: 80.h),
              // color: Colors.pink,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        SingleChildScrollView(
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
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.white, width: 2.sp),
                                      color: Colors.black45
                                      // color: Colors.red,
                                      ),
                                  child: Image.network(
                                    widget.eventDetails.logoUrl,
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
                                        fontSize: 70.sp, color: Colors.white),
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
                                      color: Colors.white,
                                      size: 100.sp,
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.eventDetails.description,
                                        style: TextStyle(
                                            fontSize: 40.sp, color: Colors.white),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                                ),
                                widget.eventDetails.subEvents.isEmpty ?Container():Container(
                                  margin: EdgeInsets.only(
                                    top: 58.h,
                                  ),
                                  child: Text(
                                    "Sub Events",
                                    style: TextStyle(
                                        fontSize: 70.sp, color: Colors.white),
                                  ),
                                ),
                                widget.eventDetails.subEvents.isEmpty ?Container():GridViewWidget(
                                    eventList: widget.eventDetails.subEvents,
                                    isSubEvent: true),
                                SizedBox(height: 100.h,),
                                Center(child: OutlinedButton(
                                  onPressed: () async {


                                      if(!registered){
                                        print("Registering Event....");

                                        List<cal.EventAttendee> attendeeEmailList = [
                                          cal.EventAttendee(
                                              email: FirebaseAuth.instance.currentUser?.email
                                                  .toString()),
                                        ];

                                        await Provider.of<UserDetailProvider>(
                                            context, listen: false).registerEvent(
                                            currUser?.uid, QRModel(
                                            widget.eventDetails.name,
                                            widget.eventDetails.eventId, "TEMP"));
                                        await Provider.of<EventDetailsProvider>(
                                            context, listen: false).addUserRegistration(widget.eventDetails.eventId,
                                            currUser?.uid);
                                        await CalenderApiProvider().addEvent(
                                            context,
                                            widget.eventDetails.name,
                                            widget.eventDetails.startTime,
                                            widget.eventDetails.endTime,
                                            attendeeEmailList,
                                            widget.eventDetails.description,
                                            widget.eventDetails.address,
                                        );
                                        loadDetails();
                                        setState(() {});
                                      }


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
                                      registered?"Registered":"Register",
                                      textAlign: TextAlign.center,

                                      style: TextStyle(color: Colors.white,fontFamily: 'JosefinSan-Light',
                                          fontWeight: FontWeight.w900 ,fontSize: 45.sp),
                                    ),
                                  ),
                                ),)
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: ListView.builder(
                                itemCount: chats.length,
                                // scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                // padding: EdgeInsets.only(top: 23.h),
                                itemBuilder: (context, position) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: chats[position].userEmail == FirebaseAuth.instance.currentUser?.email?MainAxisAlignment.end:MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    children: [
                                      Container(
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius: chats[position].userEmail == FirebaseAuth.instance.currentUser?.email?BorderRadius.only(topRight: Radius.circular(100.sp),bottomLeft: Radius.circular(100.sp), topLeft: Radius.circular(20.sp), bottomRight: Radius.circular(20.sp)):BorderRadius.only(topLeft: Radius.circular(100.sp),bottomRight: Radius.circular(100.sp), topRight: Radius.circular(20.sp), bottomLeft: Radius.circular(20.sp))
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 50.w),
                                        margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 50.w),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          // mainAxisAlignment: chats[position].userEmail == FirebaseAuth.instance.currentUser?.email?MainAxisAlignment.end:MainAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              foregroundImage: NetworkImage(
                                                  chats[position].userProfileURL),
                                              radius: 50.r,
                                            ),
                                            SizedBox(
                                              width: 50.w,
                                            ),
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: 590.w
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      chats[position].userName,
                                                      style: TextStyle(
                                                          fontSize: 40.sp, color: Colors.black87),
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  SizedBox(height: 20.h,),
                                                  Flexible(
                                                    child: Text(
                                                      chats[position].userMsg,
                                                      style: TextStyle(
                                                          fontSize: 40.sp, color: Colors.black87),
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20.h,),
                            Container(
                              // color: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              child: TextField(
                                maxLines: 2,
                                minLines: 1,
                                controller: chatBarController,
                                onChanged: (value) => {},
                                decoration: InputDecoration(
                                  hintText: "Lets chat...",
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffebebeb),
                                    ),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 100.w, vertical: 40.h),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffebebeb),
                                    ),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  hintStyle: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 50.sp,
                                    fontStyle: FontStyle.normal,
                                    color: const Color(0xffffffff),
                                  ),
                                  suffixIcon: IconButton(
                                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                                    icon: const Icon(Icons.send),
                                    color: const Color(0xffffffff),
                                    onPressed: () {
                                      print("serchpressed");
                                      if(chatBarController.text.trim().isNotEmpty){
                                        Provider.of<EventDetailsProvider>(context, listen: false).addEventDiscussions(widget.eventDetails.eventId, EventDiscussionMessageModel(currUser!.displayName as String,currUser!.email as String, chatBarController.text, DateTime.timestamp(), currUser!.photoURL as String));
                                        chatBarController.clear();
                                        loadDetails();
                                        setState(() {});
                                      }

                                    },
                                  ),
                                ),
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 45.sp,
                                  fontStyle: FontStyle.normal,
                                  color: const Color(0xffffffff),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
            ))
          ],
        ),
      ),
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

// Function to register to an Event.
