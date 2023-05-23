import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:todos/models/place_location_models.dart';
import 'package:todos/services/place_location_service.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key, required this.initialLocation});

  final PlaceLocation initialLocation;

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  // Koordinat monas
  LatLng _pickedLocation = const LatLng(-6.1754, 106.8272);

  final String _address = '';

  // Membuat controller untuk memindahkan camera dari posisi awal ke posisi yang ditentukan
  late GoogleMapController googleMapController;

  Future getUserLocation() async {
    LocationData? locationData = await LocationService().getUserLocation();
    // cek kemungkinan null
    if (locationData != null) {
      setLocation(
        LatLng(
          locationData.latitude!,
          locationData.longitude!,
        ),
      );
    }
  }

  Future setLocation(LatLng position) async {
    // Mindahin kamera ke posisi yang ditampilin
    googleMapController.moveCamera(
      CameraUpdate.newLatLng(
        position,
      ),
    );
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  void initState() {
    if (widget.initialLocation.latitude == 0 &&
        widget.initialLocation.longitude == 0) {
      getUserLocation();
    } else {
      // kalau gk null
      setLocation(
        LatLng(
          widget.initialLocation.latitude,
          widget.initialLocation.longitude,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_address),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          googleMapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _pickedLocation,
          zoom: 15,
        ),
        myLocationEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId('pickedLocation'),
            position: _pickedLocation,
          ),
        },
      ),
    );
  }
}
