import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:iiitd_evnts/models/EventDiscussionModel.dart';
import 'package:iiitd_evnts/providers/EventDetailsProvider.dart';

void main() {
  late EventDetailsProvider eventDetailsProvider;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    eventDetailsProvider = EventDetailsProvider(fakeFirestore);
  });

  group('EventDetailsProvider Tests', () {
    test('fetchGlobalEventDetails should update globalLiveEventList and globalUpcomingEventList', () async {
      final eventData = {
        "event_Id": "1",
        "event_Address": "Test Address",
        "event_Name": "Test Event",
        "event_Start_Date": DateTime.now().subtract(Duration(days: 1)),
        "event_End_Date": DateTime.now().add(Duration(days: 1)),
        "event_Club_Id": "club1",
        "event_Description": "Test Description",
        "event_Location_Url": "location_url",
        "event_Logo_Url": "logo_url",
        "event_Start_Time": "10:00",
        "event_End_Time": "11:00",
        "event_Discussion_List": [],
      };

      final eventData2 = {
        "event_Id": "2",
        "event_Address": "Test Address",
        "event_Name": "Test Event",
        "event_Start_Date": DateTime.now().add(Duration(days: 1)),
        "event_End_Date": DateTime.now().add(Duration(days: 2)),
        "event_Club_Id": "club2",
        "event_Description": "Test Description",
        "event_Location_Url": "location_url",
        "event_Logo_Url": "logo_url",
        "event_Start_Time": "10:00",
        "event_End_Time": "11:00",
        "event_Discussion_List": [],
      };


      fakeFirestore.collection("EVENTS-DETAILS-INFORMATION").add(eventData);
      fakeFirestore.collection("EVENTS-DETAILS-INFORMATION").add(eventData2);


      await eventDetailsProvider.fetchGlobalEventDetails();

      expect(eventDetailsProvider.globalLiveEventList.length, 1);
      expect(eventDetailsProvider.globalUpcomingEventList.length, 1);

      // Add more assertions if needed
    });

    test('fetchEventDetails should return correct event details', () async {
      final eventID = "1";
      final eventData = {
        "event_Id": eventID,
        "event_Name": "Test Event",
        "event_Address": "Test Address",
        "event_Start_Date": DateTime.now(),
        "event_End_Date": DateTime.now().add(Duration(hours: 1)),
        "event_Club_Id": "club1",
        "event_Description": "Test Description",
        "event_Location_Url": "location_url",
        "event_Logo_Url": "logo_url",
        "event_Start_Time": "10:00",
        "event_End_Time": "11:00",
        "event_Discussion_List": [],
        // Add more fields as needed
      };

      fakeFirestore.collection("EVENTS-DETAILS-INFORMATION").doc(eventID).set(eventData);

      final eventDetails = await eventDetailsProvider.fetchEventDetails(eventID);

      expect(eventDetails.eventId, eventID);

    });

    test('fetchEventDiscussions should return correct discussions', () async {
      final eventID = "1";
      final eventData = {
        "event_Id": eventID,
        "event_Discussion_List": [
          {
            "user_Name": "User1",
            "user_Email": "user1@example.com",
            "user_Message": "Test message",
            "TimeStamp": DateTime.now(),
            "user_ProfileURL": "profile_url",
          }
        ],
        // Add more fields as needed
      };

      fakeFirestore.collection("EVENTS-DETAILS-INFORMATION").doc(eventID).set(eventData);

      final discussions = await eventDetailsProvider.fetchEventDiscussions(eventID);

      expect(discussions.length, 1);
      // Add more assertions if needed
    });

    test('addEventDiscussions should update event discussions', () async {
      final eventID = "1";
      final eventData = {
        "event_Id": eventID,
        "event_Discussion_List": [],
        // Add more fields as needed
      };

      fakeFirestore.collection("EVENTS-DETAILS-INFORMATION").doc(eventID).set(eventData);

      final msgObject = EventDiscussionMessageModel(
        "User1",
        "user1@example.com",
        "Test message",
        DateTime.now(),
        "profile_url",
      );

      await eventDetailsProvider.addEventDiscussions(eventID, msgObject);

      final discussions = await eventDetailsProvider.fetchEventDiscussions(eventID);

      expect(discussions.length, 1);
      // Add more assertions if needed
    });
  });
}
