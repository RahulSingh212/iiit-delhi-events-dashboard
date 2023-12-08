class QRModel {
  String eventName;
  String eventId;
  String QRUrl;

  QRModel(
      this.eventName,
      this.eventId,
      this.QRUrl);

  Map<String,dynamic> convertToJSONForFirebase(){
    return <String,dynamic>{
      "event_Name":this.eventName,
      "event_Id":this.eventId,
      "qr_Url" : this.QRUrl
    };
  }

}