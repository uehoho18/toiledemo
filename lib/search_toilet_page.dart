import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:toiledemo/toilet.dart';

class SearchToiletPage extends StatefulWidget {
  const SearchToiletPage({super.key});

  @override
  _SearchToiletPageState createState() => _SearchToiletPageState();
}

class _SearchToiletPageState extends State<SearchToiletPage> {
  final apiKey = '';
  Toilet? toilet;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchLocation();
  }

  Future<void> _init() async {
    await _searchLocation();
  }

  Widget build(BuildContext context) {
    if (toilet == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('一番近くのトイレ'),
      ),
      body: Column(
        children: [
          Image.network(
            toilet!.name!,
          ),
          const Padding(padding: EdgeInsets.all(8)),
          Text(
            toilet!.name!,
            style: const TextStyle(
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

  Future<void> _searchLocation() async {
    final position = await _determinePosition();
    final longitude = position.longitude;
    final latitude = position.latitude;
    print(latitude);

    const apiKey = 'YOUR_API_KEY_HERE';
    final googlePlace = GooglePlace(apiKey);

    final response = await googlePlace.search.getNearBySearch(
      Location(lat: longitude, lng: latitude),
      1000,
      language: "ja",
      keyword: "お手洗い",
    );
    final results = response?.results;
    final firstResult = results?.first;

    if (firstResult != null && mounted) {
      final photoReference = firstResult.photos?.first.photoReference;

      setState(() {
        toilet = Toilet(
          firstResult.name,
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoReference&key=$apiKey',
          firstResult.geometry?.location,
        );
      });
    }
  }
}

//検索結果を返す

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
