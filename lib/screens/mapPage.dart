import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mini_project_five/data/global.dart';
import 'package:mini_project_five/screens/afternoonScreen.dart';
import 'package:mini_project_five/screens/morningScreen.dart';
import 'package:mini_project_five/screens/newsAnnouncement.dart';
import 'dart:async';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../services/getLocation.dart';
import '../utils/loading.dart';

class Map_Page extends StatefulWidget {
  const Map_Page({super.key});

  @override
  State<Map_Page> createState() => _Map_PageState();
}

class _Map_PageState extends State<Map_Page> with WidgetsBindingObserver {
  Timer? _timer;
  int selectedBox = 0;
  LatLng? currentLocation;
  double _heading = 0.0;
  List<LatLng> routepoints = [];
  int service_time = 9;
  bool ignoring = false;
  bool _isDarkMode = false;
  LatLng? Bus_Location;
  LocationService _locationService = LocationService();
  DateTime now = DateTime.now();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
  }

  void _getLocation() {
    _locationService.getCurrentLocation().then((location) {
      setState(() {
        currentLocation = location;
        print('Printing current location: $currentLocation');
      });
    });
    _locationService.initCompass((heading){
      setState(() {
        _heading = heading;
      });
    });
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  void updateSelectedBox(int selectedBox) {
    setState(() {
      this.selectedBox = selectedBox;
      if (selectedBox == 1)
        fetchRoute(LatLng(1.3359291665604225, 103.78307744418207));
      else if (selectedBox == 2)
        fetchRoute(LatLng(1.3157535241817033, 103.76510924418207));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    //subscription.cancel();
    //client.disconnect();
    super.dispose();
  }

  Future<void> fetchRoute(LatLng destination) async {
    LatLng start = LatLng(1.3327930713846318, 103.77771893587253);
    var url = Uri.parse(
        'http://router.project-osrm.org/route/v1/foot/${start.longitude},${start
            .latitude};${destination.longitude},${destination
            .latitude}?overview=simplified&steps=true');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        routepoints.clear();
        routepoints.add(start);
        var data = jsonDecode(response.body);

        if (data['routes'] != null) {
          String encodedPolyline = data['routes'][0]['geometry'];
          List<LatLng> decodedCoordinates = PolylinePoints()
              .decodePolyline(encodedPolyline)
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
          routepoints.addAll(decodedCoordinates);
        }
      });
    }
  }

  void _onPanelOpened() {
    setState(() {
      ignoring = true;
    });
  }

  void _onPanelClosed() {
    setState(() {
      ignoring = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget displayPage = now.hour > startAfternoonService ? Afternoon_Screen(updateSelectedBox: updateSelectedBox) : Morning_Screen(updateSelectedBox: updateSelectedBox);

    return Scaffold(
      body: currentLocation == null? LoadingScreen() : Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(currentLocation!.latitude, currentLocation!.longitude),
              initialZoom: 18,
              initialRotation: _heading,
              interactionOptions: const InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapZoom),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                tileBuilder: _isDarkMode == true
                    ? (BuildContext context, Widget tileWidget, TileImage tile) {
                  return ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      -1,  0,  0, 0, 255,
                      0, -1,  0, 0, 255,
                      0,  0, -1, 0, 255,
                      0,  0,  0, 1,   0,
                    ]),
                    child: tileWidget,
                  );
                }
                    : null,
              ),
              PolylineLayer(
                //polylineCulling: false,
                  polylines: [
                    Polyline(
                      points: routepoints,
                      color: Colors.blue,
                      strokeWidth: 5,
                      // Define a single StrokePattern
                      pattern: StrokePattern.dashed(
                        segments: [1, 7],
                        patternFit: PatternFit.scaleUp,
                      ),
                    )
                  ]),
              MarkerLayer(markers: [
                Marker(
                    point: Bus_Location ??
                        LatLng(1.3323127398440282, 103.774728443874),
                    child: Icon(
                      Icons.circle_sharp,
                      color: Colors.blueAccent,
                      size: 23,
                    )
                ),
                Marker(
                    point: currentLocation!,
                    child: CustomPaint(
                        size: Size(300, 200),
                        painter: CompassPainter(
                          direction: _heading,
                          arcSweepAngle: 360,
                          arcStartAngle: 0,
                        )
                    )
                )
              ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30.0, 10.0, 0),
                child: CircularMenu(
                    alignment: Alignment.topRight,
                    radius: 80.0,
                    toggleButtonColor: Colors.cyan,
                    curve: Curves.easeInOut,
                    items: [
                      CircularMenuItem(
                          color: Colors.yellow[300],
                          iconSize: 30.0,
                          margin: 10.0,
                          padding: 10.0,
                          icon: Icons.info_rounded,
                          onTap: () {}
                      ),
                      CircularMenuItem(
                          color: Colors.green[300],
                          iconSize: 30.0,
                          margin: 10.0,
                          padding: 10.0,
                          icon: Icons.settings,
                          onTap: () {}
                      ),
                      CircularMenuItem(
                          color: Colors.pink[300],
                          iconSize: 30.0,
                          margin: 10.0,
                          padding: 10.0,
                          icon: Icons.newspaper,
                          onTap: () {}
                      ),
                    ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 40.0, 0.0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ClipOval(
                    child: Image.asset(
                      'images/logo.jpeg',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SlidingUpPanel(
            onPanelOpened: _onPanelOpened,
            onPanelClosed: _onPanelClosed,
            panelBuilder: (controller) {
              return Container(
                color: _isDarkMode ? Colors.lightBlue[900] : Colors.lightBlue[100],
                child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'MooBus on-demand',
                              style: TextStyle(
                                color: _isDarkMode ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),
                        displayPage,
                        SizedBox(height: 16),
                        News_Announcement(),
                        SizedBox(height: 20),
                      ],
                    )
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

