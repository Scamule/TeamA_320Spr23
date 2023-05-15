//creates the Event class used by the other files to describe course or club information
abstract class Event {
  late String type;
}
//used to specify that an event is a course 
class EventType {
  static const String COURSE = "course";
}