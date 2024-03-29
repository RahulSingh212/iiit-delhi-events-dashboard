// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iiitd_evnts/models/QRModel.dart';
import 'package:iiitd_evnts/screens/SubEventScreen.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/EventModel.dart';
import '../screens/EventScreen.dart';

class QrViewWidget extends StatelessWidget {
  QrViewWidget(
      {super.key, required this.registeredEventList});

  List<QRModel> registeredEventList;

  Future showPopUp(BuildContext context, QRModel qrmodel) async {


    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              backgroundColor: Colors.white,
              // elevation: 16,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              title: TextField(
                controller: TextEditingController(text: "Event QR Ticket"),
                style: TextStyle(fontSize: 55.sp, color: Colors.black, fontWeight: FontWeight.w900),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Event QR",
                ),
                enabled: false,
              ),
              titlePadding: EdgeInsets.fromLTRB(60.w, 60.h, 80.w, 0.h),
              contentPadding: EdgeInsets.fromLTRB(70.w, 40.h, 80.w, 60.h),
              children: [
                Container(
                  // height: 1000.r,
                  width: 1000.r,
                  child: PrettyQrView.data(
                    data: 'https://iiit-delhi-events-dashboard.vercel.app/eventRegistration?uid='+qrmodel.eventId+"-"+FirebaseAuth.instance.currentUser!.uid.toString(),
                    decoration: const PrettyQrDecoration(
                      image: PrettyQrDecorationImage(
                        image: AssetImage('assets/logo.png'),
                      ),
                    ),
                  )
                  // child: QrImageView(data: qrmodel.eventId+"_"+FirebaseAuth.instance.currentUser!.uid.toString(),
                  //   version: QrVersions.auto,
                  //   gapless: true,
                  // )
                )
              ],
            );
          });
        },
        barrierColor: Colors.black.withOpacity(0.75));

    // async {
    //   date_time temp = date_time();
    //   DateTime? selectedDate =
    //   await temp.selectDate(context);
    //   TimeOfDay? selectedTime =
    //   await temp.selectTime(context);
    //   setState(
    //         () {
    //       if (selectedDate == null ||
    //           selectedTime == null) {
    //         return;
    //       }
    //       Date_Time = DateTime(
    //         selectedDate.year,
    //         selectedDate.month,
    //         selectedDate.day,
    //         selectedTime.hour,
    //         selectedTime.minute,
    //       );
    //
    //       _DayDate_Controller.text =
    //           DateFormat('hh:mm a, MMM dd')
    //               .format(Date_Time);
    //       // print(_DayDate_Controller.text);
    //     },
    //   );
    // },
  }


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
              childAspectRatio: 2.5,
              mainAxisSpacing: 40.h),
          itemCount: registeredEventList.length,
          shrinkWrap: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          itemBuilder: (context, position) {
            return InkWell(
              onTap: () {
                showPopUp(context, registeredEventList[position]
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xeaf65124),
                  // image: DecorationImage(image: NetworkImage(eventList[position].logoUrl),opacity: 0.5)
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(15.sp),
                    child: Text(
                      registeredEventList[position].eventName,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 70.sp,
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
