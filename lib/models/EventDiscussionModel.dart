class EventDiscussionMessageModel{
  String userName;
  String userEmail;
  String userMsg;
  DateTime msgTime;
  String userProfileURL;
  // bool isSelf;

  EventDiscussionMessageModel(
      this.userName, this.userEmail, this.userMsg, this.msgTime, this.userProfileURL);

  Map<String,dynamic> convertToJSONForFirebase(){
    return <String,dynamic>{
      "user_Email":this.userEmail,
      "TimeStamp":this.msgTime,
      "user_Name":this.userName,
      "user_Message":this.userMsg,
      "user_ProfileURL" : this.userProfileURL
    };
  }

}