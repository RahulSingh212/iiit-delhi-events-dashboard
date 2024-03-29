
class EventModel {
  String name;
  String address;
  String clubId;
  String clubName;
  String description;
  DateTime startTime;
  DateTime endTime;
  String eventId;
  String locationUrl;
  String logoUrl;
  List<EventModel> subEvents = <EventModel>[];

  EventModel(this.name,
      this.address,
      this.clubId,
      this.clubName,
      this.description,
      this.startTime,
      this.endTime,
      this.eventId,
      this.locationUrl,
      this.logoUrl,
      this.subEvents);
}