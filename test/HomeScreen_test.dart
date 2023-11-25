import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:mocktail/mocktail.dart'; // Import mocktail
import 'package:provider/provider.dart';
import 'package:iiitd_evnts/providers/EventDetailsProvider.dart';
import 'package:iiitd_evnts/providers/NavBarIndexProvider.dart';
import 'package:iiitd_evnts/screens/HomeScreen.dart';

class MockEventDetailsProvider extends Mock implements EventDetailsProvider {}

void main() {
  final mockUser = MockUser(
    isAnonymous: false,
    uid: 'test_user_id',
    displayName: 'Test User',
    email: 'test@example.com',
  );

  testWidgets('HomeScreen Widget Test', (WidgetTester tester) async {

    final auth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);

    final mockEventDetailsProvider = MockEventDetailsProvider();
    when(() => mockEventDetailsProvider.fetchGlobalEventDetails())
        .thenAnswer((_) async {});

    when(() => mockEventDetailsProvider.globalUpcomingEventList)
        .thenReturn([]);
    when(() => mockEventDetailsProvider.globalLiveEventList)
        .thenReturn([]);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NavBarIndexProvider>(
            create: (_) => NavBarIndexProvider(),
          ),
          ChangeNotifierProvider<EventDetailsProvider>(
            create: (context) => mockEventDetailsProvider,
          ),
        ],
        child: ScreenUtilInit(
          builder: (context, child) => MaterialApp(
            title: 'IIITD Event APP',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: HomeScreen(firebaseAuth: auth),
          ),
          designSize: const Size(1080, 2340),
        ),
      ),
    );

    await tester.idle();
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Hello,'), findsOneWidget);
    expect(find.text(mockUser.displayName as String), findsOneWidget);
  });
}
