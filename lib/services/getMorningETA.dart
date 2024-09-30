import 'package:flutter/material.dart';
import 'package:mini_project_five/utils/getTime.dart';

class Calculate_MorningBus {
  static Widget buildMorningETADisplay(String text, {String ETA = ''}) {
    return Container(
      width: 350,
      child: Card(
        color: Colors.lightBlue[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Icon(Icons.directions_bus_outlined),
              Text(
                ETA.isNotEmpty ? 'Upcoming bus: $ETA minutes' : text,
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget getMorningETA(List<DateTime> busArrivalTimes) {
    final _timeService = TimeService();
    DateTime currentTime = _timeService.time_now ?? DateTime.now();
    print('Current Time: $currentTime');
    print('Bus Timing List: $busArrivalTimes');

    List<DateTime> upcomingArrivalTimes = busArrivalTimes.where((time) => time.isAfter(currentTime)).toList();
    print('Upcoming Arrival Times: $upcomingArrivalTimes');
    print(upcomingArrivalTimes.isEmpty);


    if (upcomingArrivalTimes.isEmpty) {
      return Column(
        children: [
          buildMorningETADisplay('No upcoming buses available.'),
          buildMorningETADisplay('No upcoming buses avaiable'),
        ],
      );
    } else {
      String upcomingBus = upcomingArrivalTimes[0].difference(currentTime).inMinutes.toString();
      String nextUpcomingBus = upcomingArrivalTimes.length > 1
          ? upcomingArrivalTimes[1].difference(currentTime).inMinutes.toString()
          : ' - ';

      return Column(
        children: [
          buildMorningETADisplay('Upcoming bus:', ETA: upcomingBus),
          buildMorningETADisplay('Next bus:', ETA: nextUpcomingBus),
        ],
      );
    }
  }
}

// Widget to retrieve and display bus times
class GetMorningETA extends StatelessWidget {
  final List<DateTime> busArrivalTimes;

  const GetMorningETA(this.busArrivalTimes);

  @override
  Widget build(BuildContext context) {
    return Calculate_MorningBus.getMorningETA(busArrivalTimes);
  }
}
