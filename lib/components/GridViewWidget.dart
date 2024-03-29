// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iiitd_evnts/screens/SubEventScreen.dart';
import 'package:intl/intl.dart';

import '../models/EventModel.dart';
import '../screens/EventScreen.dart';

class GridViewWidget extends StatelessWidget {
  GridViewWidget(
      {super.key, required this.eventList, required this.isSubEvent});

  List<EventModel> eventList;
  bool isSubEvent;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        margin: EdgeInsets.only(top: 58.h),
        alignment: Alignment.topCenter,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 30.w,
              childAspectRatio: 1.8,
              mainAxisSpacing: 40.h),
          itemCount: eventList.length,
          shrinkWrap: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          itemBuilder: (context, position) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => isSubEvent
                        ? SubEventScreen(eventDetails: eventList[position])
                        : EventScreen(eventDetails: eventList[position]),
                  ),
                );
              },

              child: Container(
                // foregroundDecoration: BoxDecoration(
                //   // border: Border.all(color: Colors.white),
                //   gradient: RadialGradient(colors: [
                //     Colors.transparent,
                //     Colors.black,
                //   ], radius: 1.6.spMax, center: Alignment.topCenter),
                //   // border: Border.all(color: Colors.white)
                // ),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                      stops: [0.4,1],
                      begin: Alignment.bottomCenter,
                  end: Alignment.topCenter),
                  // color: Colors.lightBlue,
                  image: DecorationImage(image: NetworkImage(eventList[position].logoUrl),opacity: 0.8)

                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 60.w, right: 60.w),
                      child: Text(
                        eventList[position].name,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 70.sp,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 60.w,),
                        Icon(Icons.account_balance, color: Colors.white, size: 40.sp,),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(left: 20.w, right: 30.w),
                            child: Text(
                              eventList[position].clubName,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 40.sp,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w,),
                        Icon(CupertinoIcons.clock_solid, color: Colors.white, size: 40.sp,),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(left: 20.w, right: 30.w),
                            child: Text(
                               DateFormat("jm").format(eventList[position].startTime),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 40.sp,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60.h,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
