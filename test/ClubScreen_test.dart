import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:iiitd_evnts/models/ClubModel.dart';
import 'package:iiitd_evnts/providers/ClubDetailProvider.dart';
import 'package:iiitd_evnts/screens/ClubScreen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:iiitd_evnts/providers/NavBarIndexProvider.dart';

class MockClubDetailProvider extends Mock implements ClubDetailProvider {}

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

void main() {
  final mockUser = MockUser(
    isAnonymous: false,
    uid: 'test_user_id',
    displayName: 'Test User',
    email: 'test@example.com',
  );

  testWidgets('ClubScreen Widget Test', (WidgetTester tester) async {

    final auth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);


    final mockClubDetailProvider = MockClubDetailProvider();
    when(() => mockClubDetailProvider.fetchGlobalClubList())
        .thenAnswer((_) async {});

    List<ClubModel> clubList = [
      // ClubModel(
      //     "Club 1",
      //     "Club Name 1",
      //     "https://fastly.picsum.photos/id/658/536/354.jpg?hmac=lJsBY1i-cotZRX7y_Gs4NWkIaCtyhT3HhAeLnRpra8k",
      //     "Club 1 Description",
      //     [],
      //     []
      // ),
      // ClubModel(
      //     "Club 2",
      //     "Club Name 2",
      //     "https://fastly.picsum.photos/id/658/536/354.jpg?hmac=lJsBY1i-cotZRX7y_Gs4NWkIaCtyhT3HhAeLnRpra8k",
      //     "Club 2 Description",
      //     [],
      //     []
      // ),
      // ClubModel(
      //     "Club 3",
      //     "Club Name 3",
      //     "https://fastly.picsum.photos/id/658/536/354.jpg?hmac=lJsBY1i-cotZRX7y_Gs4NWkIaCtyhT3HhAeLnRpra8k",
      //     "Club 3 Description",
      //     [],
      //     []
      // )
    ];

    when(() => mockClubDetailProvider.globalClubList)
        .thenReturn(clubList);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NavBarIndexProvider>(
            create: (_) => NavBarIndexProvider(),
          ),
          ChangeNotifierProvider<ClubDetailProvider>(
            create: (context) => mockClubDetailProvider,
          ),
        ],
        child: ScreenUtilInit(
          builder: (context, child) => MaterialApp(
            title: 'IIITD Event APP',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: ClubScreen(firebaseAuth: auth),
          ),
          designSize: const Size(1080, 2340),
        ),
      ),
    );

    await tester.idle();
    await tester.pump();

    expect(find.text('Clubs'), findsOneWidget);
  });
}
