import 'EventModel.dart';

class ClubModel {
  String clubId;
  String clubName;
  String clubLogoUrl;
  String clubDescription;
  List<EventModel> liveEventList;
  List<EventModel> upcomingEventList;


  ClubModel(this.clubId, this.clubName, this.clubLogoUrl, this.clubDescription, this.liveEventList, this.upcomingEventList);
}