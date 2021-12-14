class Change {
  final List<int> days;
  final int fromHour;
  final int toHour;
  final double temp;
  const Change(this.days, this.fromHour, this.toHour, this.temp);

  Change.fromJson(Map<String, dynamic> json)
      : days = List.from(json['days']),
        fromHour = json['fromHour'],
        toHour = json['toHour'],
        temp = json['temp'].toDouble();

  Map<String, dynamic> toJson() {
    return {
      "days": days,
      "fromHour": fromHour,
      "toHour": toHour,
      "temp": temp,
    };
  }
}

class Schedule {
  final List<Change> changes;
  const Schedule({this.changes = const []});
  Schedule.fromJson(Map<String, dynamic> json)
      : changes = List.from(
            (json['changes'] as Iterable).map((e) => Change.fromJson(e)));

  Map<String, dynamic> toJson() {
    return {
      "changes": changes,
    };
  }
}
