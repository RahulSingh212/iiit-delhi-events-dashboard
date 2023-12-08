// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:iiitd_evnts/models/EventDiscussionModel.dart';
import 'package:iiitd_evnts/models/EventModel.dart';


class EventDetailsProvider extends ChangeNotifier {

  late FirebaseFirestore firebaseFireStoreInstance;
  late List<EventModel> globalLiveEventList;
  late List<EventModel> globalUpcomingEventList;

  EventDetailsProvider(FirebaseFirestore fireStore){
    firebaseFireStoreInstance = fireStore;
    globalUpcomingEventList = [];
    globalLiveEventList = [];
  }

  Future<void> fetchGlobalEventDetails() async {
    List<EventModel> tempLiveEventDetails = <EventModel>[];
    List<EventModel> tempUpcomingEventDetails = <EventModel>[];

    CollectionReference<Map<String, dynamic>> eventCollectionRef =
    firebaseFireStoreInstance.collection("EVENTS-DETAILS-INFORMATION");

    await eventCollectionRef.get().then((eventDoc) async {
      for (var currEvent in eventDoc.docs) {
        var eventDetails = currEvent.data();

        List<String> startBufferTime = (eventDetails["event_Start_Time"] as String).split(":");
        List<String> endBufferTime = (eventDetails["event_End_Time"] as String).split(":");

        DateTime startTime =
            (eventDetails["event_Start_Date"] as Timestamp).toDate().add(Duration(hours: int.parse(startBufferTime[0]), minutes: int.parse(startBufferTime[1])));
        DateTime endTime =
            (eventDetails["event_End_Date"] as Timestamp).toDate().add(Duration(hours: int.parse(endBufferTime[0]), minutes: int.parse(endBufferTime[1])));

        int isLive = checkEventLiveStatus(startTime, endTime);

        var subEventCollectionRef = eventCollectionRef
            .doc(currEvent.id).collection("SUB-EVENTS-DETAILS-INFORMATION");

        await fetchSubEventDetails(subEventCollectionRef).then((subEventList){
          EventModel event = EventModel(
              eventDetails["event_Name"],
              eventDetails["event_Address"],
              eventDetails["event_Club_Id"],
              eventDetails["event_Description"],
              startTime,
              endTime,
              eventDetails["event_Id"],
              eventDetails["event_Location_Url"],
              eventDetails["event_Logo_Url"],
              subEventList);

          if(isLive == 0){
            tempLiveEventDetails.add(event);
          }
          else{
            if(isLive == 1){
              tempUpcomingEventDetails.add(event);
            }
          }
        });
      }
    });
    globalLiveEventList = tempLiveEventDetails;
    globalUpcomingEventList = tempUpcomingEventDetails;
    notifyListeners();
  }

  Future<EventModel> fetchEventDetails(var eventID) async {

    CollectionReference<Map<String, dynamic>> eventCollectionRef =
    firebaseFireStoreInstance.collection("EVENTS-DETAILS-INFORMATION");

    return await eventCollectionRef.doc(eventID).get().then((eventDoc) async {
        var eventDetails = eventDoc.data();

        List<String> startBufferTime = (eventDetails?["event_Start_Time"] as String).split(":");
        List<String> endBufferTime = (eventDetails?["event_End_Time"] as String).split(":");

        DateTime startTime =
        (eventDetails?["event_Start_Date"] as Timestamp).toDate().add(Duration(hours: int.parse(startBufferTime[0]), minutes: int.parse(startBufferTime[1])));
        DateTime endTime =
        (eventDetails?["event_End_Date"] as Timestamp).toDate().add(Duration(hours: int.parse(endBufferTime[0]), minutes: int.parse(endBufferTime[1])));

        var subEventCollectionRef = eventCollectionRef
            .doc(eventID).collection("SUB-EVENTS-DETAILS-INFORMATION");

        return await fetchSubEventDetails(subEventCollectionRef).then((subEventList){
          return EventModel(
              eventDetails?["event_Name"],
              eventDetails?["event_Address"],
              eventDetails?["event_Club_Id"],
              eventDetails?["event_Description"],
              startTime,
              endTime,
              eventDetails?["event_Id"],
              eventDetails?["event_Location_Url"],
              eventDetails?["event_Logo_Url"],
              subEventList);
        });
    });
  }

  Future<List<EventModel>> fetchSubEventDetails(
    var subEventCollectionRef) async {
    List<EventModel> subEventList = [];

    await subEventCollectionRef.get().then((eventDoc) {
      for (var currEvent in eventDoc.docs) {
        var eventDetails = currEvent.data();

        List<String> startBufferTime = (eventDetails["subEvent_Start_Time"] as String).split(":");
        List<String> endBufferTime = (eventDetails["subEvent_End_Time"] as String).split(":");

        DateTime startTime =
        (eventDetails["subEvent_Start_Date"] as Timestamp).toDate().add(Duration(hours: int.parse(startBufferTime[0]), minutes: int.parse(startBufferTime[1])));
        DateTime endTime =
        (eventDetails["subEvent_End_Date"] as Timestamp).toDate().add(Duration(hours: int.parse(endBufferTime[0]), minutes: int.parse(endBufferTime[1])));

        subEventList.add(EventModel(
            eventDetails["subEvent_Name"],
            eventDetails["subEvent_Address"],
            eventDetails["subEvent_Club_Id"],
            eventDetails["subEvent_Description"],
            startTime,
            endTime,
            eventDetails["subEvent_Id"],
            eventDetails["subEvent_Location_Url"],
            eventDetails["subEvent_Logo_Url"],
            []));
      }
    });
    return subEventList;
  }

  Future<List<EventDiscussionMessageModel>> fetchEventDiscussions(var eventId) async {
    CollectionReference<Map<String, dynamic>> eventCollectionRef =
    firebaseFireStoreInstance.collection("EVENTS-DETAILS-INFORMATION");

    List<EventDiscussionMessageModel> tempMsgList = [];

    await eventCollectionRef.doc(eventId).get().then((eventDoc) async {
      var eventDetails = eventDoc.data();

      for(var msg in eventDetails?["event_Discussion_List"]){
        tempMsgList.add(EventDiscussionMessageModel(
            msg["user_Name"],
            msg["user_Email"],
            msg["user_Message"],
            (msg["TimeStamp"] as Timestamp).toDate(),
          msg["user_ProfileURL"])
        );
      }
    });
    tempMsgList.sort((a, b) => a.msgTime.compareTo(b.msgTime));
    return tempMsgList;
  }

  Future<bool> checkUserRegistration(var eventId, String userID) async {
    CollectionReference<Map<String, dynamic>> eventCollectionRef =
    firebaseFireStoreInstance.collection("EVENTS-DETAILS-INFORMATION");

    bool regStatus = false;

    await eventCollectionRef.doc(eventId).get().then((eventDoc) async {
      var eventDetails = eventDoc.data();

      for(var msg in eventDetails?["event_Registered_User_List"]){

        if(userID.compareTo(msg["user_Id"]) == 0) {
          regStatus = true;
          return;
        }
      }
    });
    return regStatus;
  }

  Future<void> addEventDiscussions(var eventId, EventDiscussionMessageModel msgObject) async {

    CollectionReference<Map<String, dynamic>> eventCollectionRef =
    firebaseFireStoreInstance.collection("EVENTS-DETAILS-INFORMATION");

    await eventCollectionRef.doc(eventId).update({
        "event_Discussion_List": FieldValue.arrayUnion([msgObject.convertToJSONForFirebase()])
    });
  }

  Future<void> addUserRegistration(var eventId, var userID) async {

    CollectionReference<Map<String, dynamic>> eventCollectionRef =
    firebaseFireStoreInstance.collection("EVENTS-DETAILS-INFORMATION");

    await eventCollectionRef.doc(eventId).update({
      "event_Registered_User_List": FieldValue.arrayUnion([{"user_Id":userID}])
    });
  }

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
