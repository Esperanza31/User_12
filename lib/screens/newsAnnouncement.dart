import 'package:flutter/material.dart';

import '../data/getData.dart';

class News_Announcement extends StatefulWidget {
  const News_Announcement({super.key});

  @override
  State<News_Announcement> createState() => _News_AnnouncementState();
}

class _News_AnnouncementState extends State<News_Announcement> {
  BusData _BusData = BusData();
  String _NewsContent = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _NewsContent = _BusData.News;
    print('Printing _NewsContent: $_NewsContent');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.announcement, color: Colors.orange),
                    SizedBox(width: 5.0),
                    Text(
                      'NP News Announcement',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  _NewsContent,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          )
        )
      )
      ],
    );
  }
}
