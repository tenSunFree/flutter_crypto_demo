import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimeGraphData {
  String name;
  String periods;
  String before;

  TimeGraphData(this.name, this.periods, this.before);
}

final timeDataProvider =
    StateProvider<TimeGraphData>((ref) => TimeGraphData("1M", "60", "12"));
