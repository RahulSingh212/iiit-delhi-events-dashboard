// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iiitd_evnts/screens/SubEventScreen.dart';

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
              childAspectRatio: 2.3,
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.lightBlue,
                  // image: DecorationImage(image: NetworkImage(eventList[position].logoUrl),opacity: 0.5)
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(30.sp),
                    child: Text(
                      eventList[position].name,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 60.sp,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
