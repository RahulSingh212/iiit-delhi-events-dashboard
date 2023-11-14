import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:iiitd_evnts/models/EventModel.dart';
import 'package:iiitd_evnts/providers/EventDetailsProvider.dart';

import '../models/ClubModel.dart';

class ClubDetailProvider extends ChangeNotifier{

  late FirebaseFirestore firebaseFireStoreInstance;
  late List<ClubModel> globalClubList;
  late EventDetailsProvider eventDetailsProvider;

  ClubDetailProvider(FirebaseFirestore fireStore){
    firebaseFireStoreInstance = fireStore;
    globalClubList = <ClubModel>[];
    eventDetailsProvider = EventDetailsProvider(firebaseFireStoreInstance);
  }


  Future<void> fetchGlobalClubList() async {

    List<ClubModel> tempClubDetails = <ClubModel>[];

    CollectionReference<Map<String, dynamic>> clubCollectionRef = firebaseFireStoreInstance.collection(
        "CLUBS-DETAILS-INFORMATION");

    await clubCollectionRef.get().then((clubDoc) async {
      for (var currClub in clubDoc.docs) {
        var clubDetails = currClub.data();

        tempClubDetails.add(ClubModel(
            clubDetails["club_Id"],
            clubDetails["club_Name"],
            clubDetails["club_Logo_Url"],
            clubDetails["club_Description"],
            [],
            []
        ));
      }
    });
    globalClubList = tempClubDetails;
    notifyListeners();
  }

  Future<ClubModel> fetchClubEventDetails(ClubModel club) async {

    DocumentReference<Map<String, dynamic>> clubDocumentRef = firebaseFireStoreInstance.collection(
        "CLUBS-DETAILS-INFORMATION").doc(club.clubId);

    club.liveEventList = [];
    club.upcomingEventList = [];

    await clubDocumentRef.get().then((clubDoc) async {

        var clubDetails = clubDoc.data();

        for(var event in clubDetails?["club_Events_List"]){
          EventModel eventDetails = await eventDetailsProvider.fetchEventDetails(event);

          int isLive = checkEventLiveStatus(eventDetails.startTime, eventDetails.endTime);
          if(isLive == 0){
            club.liveEventList.add(eventDetails);
          }
          else{
            if(isLive == 1){
              club.upcomingEventList.add(eventDetails);
            }
          }
        }
    });

    return club;
  }

  // Future<EventModel> fetchEventDetails(String documentID) async {
  //
  //   late EventModel tempEventDetails;
  //
  //   CollectionReference<Map<String, dynamic>> eventCollectionRef = FirebaseFirestore.instance.collection(
  //       "EVENTS-DETAILS-INFORMATION");
  //
  //   await eventCollectionRef.doc(documentID).get().then((eventDoc) async {
  //     var eventDetails = eventDoc.data();
  //
  //     List<String> startBufferTime = (eventDetails?["event_Start_Time"] as String).split(":");
  //     List<String> endBufferTime = (eventDetails?["event_End_Time"] as String).split(":");
  //
  //     DateTime startTime =
  //     (eventDetails?["event_Start_Date"] as Timestamp).toDate().add(Duration(hours: int.parse(startBufferTime[0]), minutes: int.parse(startBufferTime[1])));
  //     DateTime endTime =
  //     (eventDetails?["event_End_Date"] as Timestamp).toDate().add(Duration(hours: int.parse(endBufferTime[0]), minutes: int.parse(endBufferTime[1])));
  //
  //     int isLive = checkEventLiveStatus(startTime, endTime);
  //
  //     var subEventCollectionRef = eventCollectionRef.doc(documentID).collection("SUB-EVENTS-DETAILS-INFORMATION");
  //
  //     await fetchSubEventDetails(subEventCollectionRef).then((subEventList){
  //       tempEventDetails = EventModel(
  //           eventDetails?["event_Name"],
  //           eventDetails?["event_Address"],
  //           eventDetails?["event_Club_Id"],
  //           eventDetails?["event_Description"],
  //           startTime,
  //           endTime,
  //           eventDetails?["event_Id"],
  //           eventDetails?["event_Location_Url"],
  //           eventDetails?["event_Logo_Url"],
  //           subEventList);
  //     });
  //   },onError: (e) => developer.log("Error Fetching UserData : $e",
  //       name: runtimeType.toString()));
  //   return tempEventDetails;
  // }
  //
  // Future<List<EventModel>> fetchSubEventDetails(
  //     var subEventCollectionRef) async {
  //   List<EventModel> subEventList = [];
  //
  //   await subEventCollectionRef.get().then((eventDoc) {
  //     for (var currEvent in eventDoc.docs) {
  //       var eventDetails = currEvent.data();
  //
  //       List<String> startBufferTime = (eventDetails["subEvent_Start_Time"] as String).split(":");
  //       List<String> endBufferTime = (eventDetails["subEvent_End_Time"] as String).split(":");
  //
  //       DateTime startTime =
  //       (eventDetails["subEvent_Start_Date"] as Timestamp).toDate().add(Duration(hours: int.parse(startBufferTime[0]), minutes: int.parse(startBufferTime[1])));
  //       DateTime endTime =
  //       (eventDetails["subEvent_End_Date"] as Timestamp).toDate().add(Duration(hours: int.parse(endBufferTime[0]), minutes: int.parse(endBufferTime[1])));
  //
  //       subEventList.add(EventModel(
  //           eventDetails["subEvent_Name"],
  //           eventDetails["subEvent_Address"],
  //           eventDetails["subEvent_Club_Id"],
  //           eventDetails["subEvent_Description"],
  //           startTime,
  //           endTime,
  //           eventDetails["subEvent_Id"],
  //           eventDetails["subEvent_Location_Url"],
  //           eventDetails["subEvent_Logo_Url"],
  //           []));
  //     }
  //   });
  //   return subEventList;
  // }
  //
  int checkEventLiveStatus(DateTime startTime, DateTime endTime) {
    if (startTime.isBefore(DateTime.now())) {
      if (endTime.isAfter(DateTime.now())) {
        return 0; //Live
      } else {
        return -1; // Previous
      }
    } else {
      return 1; // Upcoming
    }
  }

}