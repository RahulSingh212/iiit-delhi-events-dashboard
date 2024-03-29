// ignore_for_file: file_names, unused_local_variable, avoid_unnecessary_containers, prefer_const_constructors, unused_import

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iiitd_evnts/models/ClubModel.dart';
import '../screens/ClubEventsScreen.dart';

//ignore: must_be_immutable
class ClubCard extends StatefulWidget {
  ClubCard({Key? key, required this.clubDetails}) : super(key: key);

  // late int position;
  // late EventServerInformation eventDetails;

  ClubModel clubDetails;
  @override
  State<ClubCard> createState() => _ClubCardState();
}

class _ClubCardState extends State<ClubCard> {

  // String backImage = "https://firebasestorage.googleapis.com/v0/b/riise-application.appspot.com/o/DefaultImages%2Fbackground.jpg?alt=media&token=876903fd-25f4-40b8-9c9b-2ab4bddce3d2";
  // TODO -> Add Flex to Text.....
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClubEventsScreen(clubDetails: widget.clubDetails),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage("assets/Illstration.png"),
          //   fit: BoxFit.fill,
          // ),
          borderRadius: BorderRadius.circular(15),
          color: Color(0xeaf65124),
          // color: Colors.red,
        ),
        child: Card(
          elevation: 8,
          // color: Colors.red,
          child: Container(
            color: Color(0xeaf65124),
              padding: EdgeInsets.symmetric(
                  horizontal: 54.w, vertical: 40.h),
            // color: Colors.yellow,
            // child: Container(
            //   margin: EdgeInsets.symmetric(
            //       horizontal: 54.w, vertical: 40.h),
            //
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Flexible(
            //             child: Text(
            //               widget.clubDetails.clubName,
            //               style: TextStyle(fontSize: 40.sp,
            //                   color: Colors.white),
            //               softWrap: true,
            //             ),
            //           ),
            //         ],
            //       ),
            //       SizedBox(height: 46.8.h),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         // crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Icon(
            //             Icons.notes
            //             // size: ,
            //           ),
            //           Flexible(
            //             child: InkWell(
            //               onTap: (){
            //                 // _launchDirectionsUrl(, widget.eventDetails.Event_Longitude);
            //               },
            //               child: Text(
            //                 widget.clubDetails.clubDescription,
            //                 style: TextStyle(fontSize: 35.sp,
            //                   color: Colors.white
            //                 ),
            //                 softWrap: true,
            //                 maxLines: 1,
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    widget.clubDetails.clubName,
                    style: TextStyle(fontSize: 60.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    softWrap: true,
                  ),
                    SizedBox(height: 46.8.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notes,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.w,),
                        Flexible(
                          child: Text(
                            widget.clubDetails.clubDescription,
                            style: TextStyle(fontSize: 40.sp,
                                color: Colors.white),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                CircleAvatar(
                  foregroundImage: NetworkImage(
                      widget.clubDetails.clubLogoUrl),
                  radius: 130.r,

                ),
              ],
            ),
          ),
        ),
      ),
    );

  }

//   Future<void> _launchDirectionsUrl(String coordinateLatitude, String coordinateLongitude) async {
//     Uri url = Uri.parse(
//         'https://www.google.com/maps/dir/?api=1&destination=$coordinateLatitude,$coordinateLongitude&travelmode=walking');
//
//     if (!await launchUrl(
//       url,
//       mode: LaunchMode.externalApplication,
//     )) {
//       throw Exception('Could not launch $url');
//     }
//   }
//
}
