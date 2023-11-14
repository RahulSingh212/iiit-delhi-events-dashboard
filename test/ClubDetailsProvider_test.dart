import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iiitd_evnts/models/ClubModel.dart';
import 'package:iiitd_evnts/models/EventModel.dart';
import 'package:iiitd_evnts/providers/EventDetailsProvider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:iiitd_evnts/providers/ClubDetailProvider.dart';

class MockEventDetailsProvider extends Mock implements EventDetailsProvider {}

void main() {
  late ClubDetailProvider clubDetailProvider;
  late FakeFirebaseFirestore fakeFirestore;
  late MockEventDetailsProvider mockEventDetailsProvider;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockEventDetailsProvider = MockEventDetailsProvider();
    clubDetailProvider = ClubDetailProvider(fakeFirestore);
    clubDetailProvider.eventDetailsProvider = mockEventDetailsProvider;
  });

  group('ClubDetailProvider Tests', () {
    test('fetchGlobalClubList should populate globalClubList', () async {
      // Arrange

      ClubModel testClubModel =
          ClubModel("1", "Test Club", "logo_Url", "Test Description", [], []);

      fakeFirestore.collection('CLUBS-DETAILS-INFORMATION').add({
        'club_Id': '1',
        'club_Name': 'Test Club',
        'club_Logo_Url': 'logo_Url',
        'club_Description': 'Test Description',
        'club_Events_List': []
      });

      // Act
      await clubDetailProvider.fetchGlobalClubList();

      // Assert
      expect(clubDetailProvider.globalClubList.length, 1);
      expect(clubDetailProvider.globalClubList[0].clubId, testClubModel.clubId);
      expect(clubDetailProvider.globalClubList[0].clubName,
          testClubModel.clubName);
      expect(clubDetailProvider.globalClubList[0].clubLogoUrl,
          testClubModel.clubLogoUrl);
      expect(clubDetailProvider.globalClubList[0].clubDescription,
          testClubModel.clubDescription);
    });

    test(
        'fetchClubEventDetails should update liveEventList and upcomingEventList',
        () async {
      final clubData = {
        "club_Id": "1",
        "club_Events_List": [
          {
            "event_Name": "Test Event 1",
            "event_Address": "Test Address",
            "event_Club_Id": "1",
            "event_Description": "Test Description",
            "event_Start_Date": DateTime.now().subtract(Duration(days: 1)).toString(),
            "event_End_Date": DateTime.now().add(Duration(days: 1)).toString(),
            "event_Id": "1",
            "event_Location_Url": "location_url",
            "event_Logo_Url": "logo_url",
          },
          {
            "event_Name": "Test Event 2",
            "event_Address": "Test Address",
            "event_Club_Id": "1",
            "event_Description": "Test Description",
            "event_Start_Date": DateTime.now().add(Duration(days: 1)).toString(),
            "event_End_Date": DateTime.now().add(Duration(days: 2)).toString(),
            "event_Id": "2",
            "event_Location_Url": "location_url",
            "event_Logo_Url": "logo_url",
          },
        ],
      };

      ClubModel club = ClubModel(
        "1",
        "Test Club",
        "logo_url",
        "Test Description",
        [],
        [],
      );

      EventModel event = EventModel(
          'Test Event',
          "Test Address",
          "1",
          'Test Description',
          DateTime.now(),
          DateTime.now().add(Duration(days: 1)),
          "1",
          "location_url",
          "logo_url", []);

      final clubDocRef =
          fakeFirestore.collection("CLUBS-DETAILS-INFORMATION").doc("1");
      await clubDocRef.set(clubData);

      // Mock the behavior of EventDetailsProvider
      when(() => mockEventDetailsProvider.fetchEventDetails(any())).thenAnswer(
        (invocation) async {
          // Create a mock EventModel here or return a predefined one
          return event;
        },
      );

      expect(club.liveEventList.length, 0);

      club = await clubDetailProvider.fetchClubEventDetails(club);

      // Add assertions based on the expected behavior
      expect(club.liveEventList.length, 2);
      expect(club.liveEventList[0].clubId, event.clubId);
      expect(club.liveEventList[0].clubId, event.clubId);

    });

    test('checkEventLiveStatus should return correct status', () {
      // Arrange
      final pastEvent = DateTime.now().subtract(Duration(days: 1));
      final currentEvent = DateTime.now();
      final futureEvent = DateTime.now().add(Duration(days: 1));

      // Act & Assert
      expect(
          clubDetailProvider.checkEventLiveStatus(
              pastEvent, currentEvent.subtract(Duration(minutes: 1))),
          equals(-1));
      expect(clubDetailProvider.checkEventLiveStatus(pastEvent, futureEvent),
          equals(0));
      expect(
          clubDetailProvider.checkEventLiveStatus(
              futureEvent, futureEvent.add(Duration(days: 1))),
          equals(1));
    });
  });
}
