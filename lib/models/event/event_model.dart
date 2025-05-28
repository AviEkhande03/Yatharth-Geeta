class Event {
  final String eventBgImgUrl;
  final String eventGurujiImgUrl;
  final String eventName;
  final String eventGurujiName;
  final String eventTimings;
  final String eventDate;
  final String eventDescription;

  Event({
    this.eventBgImgUrl = '',
    this.eventDate = '',
    this.eventDescription = '',
    this.eventGurujiImgUrl = '',
    this.eventGurujiName = '',
    this.eventName = '',
    this.eventTimings = '',
  });
}

class EventModel {
  final String eventHeading;
  final List<Event> eventsList;

  EventModel({
    this.eventHeading = '',
    this.eventsList = const [],
  });
}

class EventDetails {
  final String eventBgImgUrl;
  final String eventName;
  final String eventOrganizer;
  final String eventBrief;
  final String aboutEvent;
  final String eventTimings;
  final String eventDate;
  final String eventLocation;
  final String eventMapImgUrl;

  EventDetails({
    this.aboutEvent = '',
    this.eventBgImgUrl = '',
    this.eventBrief = '',
    this.eventDate = '',
    this.eventLocation = '',
    this.eventMapImgUrl = '',
    this.eventName = '',
    this.eventOrganizer = '',
    this.eventTimings = '',
  });
}
