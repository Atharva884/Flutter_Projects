import 'dart:convert';

import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});
  final void Function(PlaceLocation pickedLocation) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? location;
  var findingLocation = false;

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    setState(() {
      findingLocation = true;
    });

    final locationData = await Geolocator.getCurrentPosition();

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    getAddress(lat, lng);
  }

  String get locationImage {
    if (location == null) {
      return '';
    }

    final lat = location!.latitude;
    final lng = location!.longitude;

    return "https://maps.googleapis.com/maps/api/staticmap?center$lat,$lng=zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:I%7C$lat,$lng&key=AIzaSyDBOq_zyB7yKBIne01xiu7rfLMNqHTQ_BQ";
  }

  void getAddress(lat, lng) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyDBOq_zyB7yKBIne01xiu7rfLMNqHTQ_BQ");
    final response = await http.get(url);
    final resData = jsonDecode(response.body);

    final address = resData['results'][0]['formatted_address'];

    setState(() {
      location = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      findingLocation = false;
    });

    widget.onSelectLocation(location!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No Choosen Location",
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );

    if (findingLocation) {
      previewContent = Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (location != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          width: double.infinity,
          height: 250,
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on_outlined),
              label: const Text("Get Current Location"),
            ),
            TextButton.icon(
              onPressed: () async {
                final pickedLocation = await Navigator.of(context).push<LatLng>(
                  MaterialPageRoute(
                    builder: (ctx) => const MapsScreen(),
                  ),
                );

                if (pickedLocation == null) {
                  return;
                }
                getAddress(pickedLocation.latitude, pickedLocation.longitude);
              },
              icon: const Icon(Icons.map),
              label: const Text("Set On Map"),
            )
          ],
        )
      ],
    );
  }
}
