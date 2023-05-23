import 'package:flutter/material.dart';
import 'package:todos/models/place_location_models.dart';
import 'package:todos/pages/screen/map_screen.dart';
import 'package:todos/services/place_location_service.dart';

class MapsWidget extends StatelessWidget {
  const MapsWidget({super.key, required this.placeLocation});
  final PlaceLocation placeLocation;

  @override
  Widget build(BuildContext context) {
    // Untuk menampilkan maps nya
    String previewMapsImageUrl = LocationService.generateMapUrlImage(
      placeLocation.latitude,
      placeLocation.longitude,
    );
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MapsScreen(initialLocation: placeLocation);
            },
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: previewMapsImageUrl.isEmpty
            ? const Center(
                child: Text(
                  'Ketuk untuk tambahkan Lokasi',
                ),
              )
            // Sudah berhasil, tpi kalau 0.0 kita dittengah laut
            : Image.network(
                previewMapsImageUrl,
              ),
      ),
    );
  }
}
