import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:favourite_places/models/place.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({
    super.key,
    this.pickedLocation = const PlaceLocation(
      latitude: 19.0166765,
      longitude: 72.8429294,
      address: '',
    ),
    this.isSelecting = true,
  });

  final PlaceLocation pickedLocation;
  final bool isSelecting;

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  LatLng? _pickedLocation;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? "Pick Your Location" : "Your Location"),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting ? null : (position) {
          setState(() {
            _pickedLocation = position;
          });
        },
        initialCameraPosition: CameraPosition(
          zoom: 16,
          target: LatLng(
            widget.pickedLocation.latitude,
            widget.pickedLocation.longitude,
          ),
        ),
        markers: (_pickedLocation == null && widget.isSelecting) ? {} : {
          Marker(
            markerId: const MarkerId("m1"),
            position: _pickedLocation ?? LatLng(
              widget.pickedLocation.latitude,
              widget.pickedLocation.longitude,
            ),
          )
        },
      ),
    );
  }
}
