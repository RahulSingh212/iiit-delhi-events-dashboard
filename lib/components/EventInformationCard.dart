// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iiitd_evnts/models/EventModel.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventInformationCard extends StatelessWidget {
  EventInformationCard({
    super.key,
    required this.position,
    required this.eventDetails
  });

  int position;
  EventModel eventDetails;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(
            "Event Information Button Pressed!!!!");
      },
      child: Container(
        // color: red,
        height: 100.h,
        width: 250.w,
        decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(25),
            color: Color(0xeaf65124)),
        padding: EdgeInsets.all(30.r),
        child: Center(
          child: position == 0?timeWidget(context, eventDetails.startTime):position==1?timeWidget(context, eventDetails.endTime):locationWidget(context, eventDetails.locationUrl, eventDetails.address),
        ),
      ),
    );
  }

  Widget timeWidget(BuildContext context, DateTime time){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(CupertinoIcons.clock_solid, size: 80.r,color: Colors.white),
        SizedBox(height: 15.h,),
        Flexible(child: Text(DateFormat.jm().format(time), style: TextStyle(fontSize: 40.sp,fontWeight: FontWeight.w600,color: Colors.white),textAlign: TextAlign.center,)),
        Flexible(child: Text(DateFormat.yMMMMd('en_US').format(time), style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.w500,color: Colors.white),textAlign: TextAlign.center,)),
      ],
    );
  }

  Widget locationWidget(BuildContext context, String locationUrl, String address){
    return InkWell(
      onTap: (){
        _launchDirectionsUrl(locationUrl);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.location_solid, size: 80.r,color: Colors.white),
          SizedBox(height: 15.h,),
          // Text(DateFormat.jm().format(time), style: TextStyle(fontSize: 40.sp,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
          Flexible(child: Text(address, style: TextStyle(fontSize: 33.sp,fontWeight: FontWeight.w500,color: Colors.white),textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}

Future<void> _launchDirectionsUrl(
    String locationURL) async {
  Uri url = Uri.parse(
      locationURL);

  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}
