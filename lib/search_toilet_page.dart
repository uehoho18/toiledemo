import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

class SearchToiletPage extends StatefulWidget {
  const SearchToiletPage({super.key});

  @override
  _SearchToiletPageState createState() => _SearchToiletPageState();
}

class _SearchToiletPageState extends State<SearchToiletPage> {
  @override
  void initState() async {
    // TODO: implement initState
    super.initState();

    final position = await _determinePosition();
    final longitude = position.longitude;
    final latitude = position.latitude;
    final a = 1;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('トイレなう'),
      ),
      body: Column(
        children: [
          Image.network(
              'https://lh5.googleusercontent.com/p/AF1QipPL_gtOMjCn64Xa1Aq9WDUMHIEOCWdTo9OTB7_x=w408-h306-k-no'),
          const Padding(padding: EdgeInsets.all(8)),
          const Text(
            'トイレ名',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          ElevatedButton(
              onPressed: () {
                // TODO:GoogleMapに遷移
              },
              child: const Text('GoogleMapに遷移'))
        ],
      ),
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('位置情報を許可してください');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('位置情報を許可してください');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('位置情報を許可してください');
  }

  return await Geolocator.getCurrentPosition();
}
