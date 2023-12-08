import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;

Map<String,dynamic> convertToJSON(User currUser){

  return <String,dynamic>{
    "uid":currUser.uid,
    "displayName":currUser.displayName,
    "email":currUser.email
  };
}

class LoginProvider extends ChangeNotifier {

  final userRef = FirebaseFirestore.instance.collection("USER-DETAILS-INFORMATION");

  Future<void> loginWithGoogle() async {
    UserCredential userCred = await signInWithGoogle();
    User? currUser = userCred.user;

    developer.log("ID -> ${currUser?.uid}", name: runtimeType.toString());

    if (await checkIsUserAlreadyPresent()) {
      developer.log("Already Present", name: runtimeType.toString());
    } else {
      developer.log("Adding UserProfile to FireStore",
          name: runtimeType.toString());
      await addUserToDataSet();
    }

    notifyListeners();
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ['https://www.googleapis.com/auth/calendar']).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> logOut() async {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<bool> checkIsUserAlreadyPresent() async {
    bool result = false;
    User? currUser = FirebaseAuth.instance.currentUser;

    await userRef.get().then(
      (userProfiles) {
        for (var currUserDoc in userProfiles.docs) {
          if (currUser?.uid.compareTo(currUserDoc.id) == 0) {
            result = true;
            break;
          }
        }
      },
      onError: (e) => developer.log("Error fetching UserProfile: $e",
          name: runtimeType.toString()),
    );

    return Future.value(result);
  }

  Future<void> addUserToDataSet() async {

    User? currUser = FirebaseAuth.instance.currentUser;
    await userRef
        .doc(currUser?.uid)
        .set(convertToJSON(currUser!))
        .onError((e, _) => developer.log(
            "Error writing User Profile to FireBase: $e",
            name: runtimeType.toString()));

    await userRef.doc(currUser.uid).update({"registered_Event_List": FieldValue.arrayUnion([])});

  }
}
