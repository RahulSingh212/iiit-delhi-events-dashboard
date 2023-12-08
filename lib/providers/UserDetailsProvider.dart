import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:iiitd_evnts/models/EventModel.dart';
import 'package:iiitd_evnts/models/QRModel.dart';
import 'package:iiitd_evnts/providers/EventDetailsProvider.dart';

import '../models/ClubModel.dart';

class UserDetailProvider extends ChangeNotifier{

  late FirebaseFirestore firebaseFireStoreInstance;

  List<QRModel> registeredList = [];

  UserDetailProvider(FirebaseFirestore fireStore){
    firebaseFireStoreInstance = fireStore;
  }

  Future<void> fetchUserRegisteredList(var userID) async {

    List<QRModel> tempRegisteredList = <QRModel>[];

    DocumentReference<Map<String, dynamic>> userDocumentRef = firebaseFireStoreInstance.collection(
        "USER-DETAILS-INFORMATION").doc(userID);

    await userDocumentRef.get().then((userDoc) async {

        var userDetails = userDoc.data();

        for(var qrEvent in userDetails?["registered_Event_List"]){
          tempRegisteredList.add(QRModel(
              qrEvent["event_Name"],
              qrEvent["event_Id"],
              qrEvent["qr_Url"]));}
        }
    );
    registeredList = tempRegisteredList;
    notifyListeners();
  }

  Future<void> registerEvent(var userId, QRModel qrObject) async {

    CollectionReference<Map<String, dynamic>> userCollectionRef = firebaseFireStoreInstance.collection(
        "USER-DETAILS-INFORMATION");

    await userCollectionRef.doc(userId).update({
      "registered_Event_List": FieldValue.arrayUnion([qrObject.convertToJSONForFirebase()])
    });
  }
}