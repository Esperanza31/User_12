import 'package:http/http.dart' as http;
import 'dart:convert';import 'dart:async';
import 'package:http/http.dart';

class BusData {
  static final BusData _instance = BusData._internal();
  factory BusData() => _instance;
  BusData._internal();

  final List<DateTime> KAPArrivalTime = [];
  final List<DateTime> CLEArrivalTime = [];
  final List<DateTime> KAPDepartureTime = [];
  final List<DateTime> CLEDepartureTime = [];
  final List<String> BusStop = [];
  String News = '';
  bool isDataLoaded = false;


  Future<void> BusStops() async{
    try {
      Response response = await get(Uri.parse(
          'https://lrjwl7ccg1.execute-api.ap-southeast-2.amazonaws.com/prod/busstop?info=BusStops'));
      dynamic data = jsonDecode(response.body);


      List<dynamic> positions = data['positions'];
      for (var position in positions) {
        String id = position['id'];
        BusStop.add(id);
        print(id);
      }

    }
    catch (e) {
      print('caugh error: $e');
    }
  }

  Future<void> NPNews() async{
    try {
      Response response = await get(Uri.parse(
          'https://lrjwl7ccg1.execute-api.ap-southeast-2.amazonaws.com/prod/news?info=News'));
      dynamic data = jsonDecode(response.body);
      String newsContent = data['news'];
      News = newsContent;
    }
    catch (e) {
      print('caugh error: $e');
    }
  }

  Future<void> KAP_AT() async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://lrjwl7ccg1.execute-api.ap-southeast-2.amazonaws.com/prod/timing?info=KAP_MorningBus'));
      dynamic data = jsonDecode(response.body);

      List<dynamic> times = data['times'];
      for (var time in times) {
        String timeStr = time['time'];
        final parts = timeStr.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        KAPArrivalTime.add(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute));
      }
    } catch (e) {
      print('caught error: $e');
    }
  }

  Future<void> CLE_AT() async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://lrjwl7ccg1.execute-api.ap-southeast-2.amazonaws.com/prod/timing?info=CLE_MorningBus'));
      dynamic data = jsonDecode(response.body);

      List<dynamic> times = data['times'];
      for (var time in times) {
        String timeStr = time['time'];
        final parts = timeStr.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        CLEArrivalTime.add(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute));
      }
    } catch (e) {
      print('caught error: $e');
    }
  }

  Future<void> KAP_DT() async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://lrjwl7ccg1.execute-api.ap-southeast-2.amazonaws.com/prod/timing?info=KAP_AfternoonBus'));
      dynamic data = jsonDecode(response.body);

      List<dynamic> times = data['times'];
      for (var time in times) {
        String timeStr = time['time'];
        final parts = timeStr.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        KAPDepartureTime.add(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute));
      }
    } catch (e) {
      print('caught error: $e');
    }
  }

  Future<void> CLE_DT() async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://lrjwl7ccg1.execute-api.ap-southeast-2.amazonaws.com/prod/timing?info=CLE_AfternoonBus'));
      dynamic data = jsonDecode(response.body);

      List<dynamic> times = data['times'];
      for (var time in times) {
        String timeStr = time['time'];
        final parts = timeStr.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        CLEDepartureTime.add(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute));
      }
    } catch (e) {
      print('caught error: $e');
    }
  }
  Future<void> loadData() async {
    if (!isDataLoaded) {
      await KAP_AT();
      await CLE_AT();
      await KAP_DT();
      await CLE_DT();
      await NPNews();
      await BusStops();
      await BusData();
      isDataLoaded = true;
    }
  }
}

