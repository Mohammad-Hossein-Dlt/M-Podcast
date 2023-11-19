abstract class SearchEvent {}

class FirstSearchResultData implements SearchEvent {
  int offset;
  String topic;
  String by;
  FirstSearchResultData(
      {required this.offset, required this.topic, required this.by});
}

class LoadMoreSearchResultData implements SearchEvent {
  int offset;
  String topic;
  String by;
  LoadMoreSearchResultData(
      {required this.offset, required this.topic, required this.by});
}

class FirstSearchByLabelResultData implements SearchEvent {
  int offset;
  String topic;
  String by;
  FirstSearchByLabelResultData(
      {required this.offset, required this.topic, required this.by});
}

class LoadMoreSearchByLabelResultData implements SearchEvent {
  int offset;
  String topic;
  String by;

  LoadMoreSearchByLabelResultData(
      {required this.offset, required this.topic, required this.by});
}

class SearchDefaultEvent implements SearchEvent {}

class DocumentDeleteEvent implements SearchEvent {
  String name;
  int id;
  DocumentDeleteEvent({
    required this.name,
    required this.id,
  });
}
