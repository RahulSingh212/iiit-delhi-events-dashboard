import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iiitd_evnts/providers/ClubDetailProvider.dart';
import 'package:iiitd_evnts/providers/EventDetailsProvider.dart';
import 'package:iiitd_evnts/providers/LoginProvider.dart';
import 'package:iiitd_evnts/providers/NavBarIndexProvider.dart';
import 'package:iiitd_evnts/providers/UserDetailsProvider.dart';
import 'package:iiitd_evnts/screens/LoginScreen.dart';
import 'package:iiitd_evnts/screens/NavBarScreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(create: (_)=>LoginProvider()),
        ChangeNotifierProvider<NavBarIndexProvider>(create: (_)=>NavBarIndexProvider()),
        ChangeNotifierProvider<EventDetailsProvider>(create: (_)=>EventDetailsProvider(fireStore)),
        ChangeNotifierProvider<ClubDetailProvider>(create: (_)=>ClubDetailProvider(fireStore)),
        ChangeNotifierProvider<UserDetailProvider>(create: (_)=>UserDetailProvider(fireStore))
      ],
      child: ScreenUtilInit(
        builder: (context, child) => MaterialApp(
          title: 'IIITD Event APP',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: StreamBuilder(
            stream: auth.authStateChanges(),
            builder: (context, userSnapShot) {
              if(userSnapShot.hasData){
                return NavBarScreen();
              }
              else{
                return LoginPage();
              }
            },
          ),
        ),
        designSize: const Size(1080,2340),
      ),
    );
  }
}
