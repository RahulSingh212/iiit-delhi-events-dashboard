
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:http/http.dart';
import 'package:googleapis/calendar/v3.dart';

class CalenderApiProvider extends ChangeNotifier {

  addEvent(
      BuildContext context,
      String name,
      DateTime startTime,
      DateTime endTime,
      List<EventAttendee> attendeesList,
      String descp,
      String location) async {
    // fetchSchedules(context, "Faculty", "Faculty-Schedule-List", attendeesList[1].email.toString());

    GoogleSignIn? googleUser = await GoogleSignIn(
        scopes: ['https://www.googleapis.com/auth/calendar']);
    final GoogleSignInAccount = await googleUser.signInSilently();

    final googleAuth = await GoogleSignInAccount?.authentication;
    final accessToken = googleAuth?.accessToken;

    print("ACCESS TOKEN _> $accessToken");

    final httpClient = authenticatedClient(
      Client(),
      AccessCredentials(
        AccessToken(
          'Bearer',
          accessToken!,
          DateTime.now()
              .add(
            Duration(
              minutes: 5,
            ),
          )
              .toUtc(),
        ),
        null,
        [],
      ),
    );
    final calendar = CalendarApi(httpClient);

    print("Start Time -> $startTime");
    print("Start Time -> $endTime");
    print("Start Time -> $name");
    print("Start Time -> $descp");

    final event = Event()
      ..summary = name
      ..attendees = attendeesList
      ..description = descp
      ..location = location
      ..start = (EventDateTime()..dateTime = startTime.toUtc())
      ..end = (EventDateTime()..dateTime = endTime.toUtc());

    print("Adding EVENT");

    try {
      print("Hello 1");
      var tempEvent = await calendar.events.insert(event, 'primary',
          sendNotifications: true, sendUpdates: 'all');
      print("Hello 2");
    } catch (e) {
      print("Error -> $e");
    }
    ;
  }

}
