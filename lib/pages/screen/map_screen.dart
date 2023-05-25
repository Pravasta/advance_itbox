import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:todos/models/place_location_models.dart';
import 'package:todos/services/place_location_service.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen(
      {super.key, required this.initialLocation, required this.setLocationFn});

  final PlaceLocation initialLocation;
  final Function(PlaceLocation placeLocation) setLocationFn;

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  // Koordinat monas
  LatLng _pickedLocation = const LatLng(-6.1754, 106.8272);

  String _address = '';

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
        // Pass move jadi true, disini karena akan dijalan kan pertama kali ketika dibuka
        moveCamera: true,
      );
    }
  }

  Future setLocation(LatLng position, {bool moveCamera = false}) async {
    // Saat set location kita akan ubah / setstate tampilan appbar
    // kenapa tuker tempat, karena biar google masp controller tidak mengalami error
    // Jadi biar ketika sudah pilih lokasi, lalu mau pilih lagi, bisa tanpa ada error
    // Oleh karena itu kita pindah in dulu await get place dulu dan beri waktu buat nunggu, baru dibuat controller nya
    String tempAddress = await LocationService()
        .getPlaceAddress(position.latitude, position.longitude);
    // Lalu tunggu dulu 500 milli second
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    // Mindahin kamera ke posisi yang ditampilin
    if (moveCamera) {
      googleMapController.moveCamera(
        CameraUpdate.newLatLng(
          position,
        ),
      );
    }

    setState(() {
      _pickedLocation = position;
      _address = tempAddress;
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
        moveCamera: true,
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
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              googleMapController = controller;
            },
            // set location baru
            onTap: setLocation,
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
          Positioned(
            bottom: 0,
            left: 50,
            right: 50,
            child: ElevatedButton(
              onPressed: () {
                widget.setLocationFn(
                  PlaceLocation(
                    latitude: _pickedLocation.latitude,
                    longitude: _pickedLocation.longitude,
                    addres: _address,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text(
                'Pilih Lokasi',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
