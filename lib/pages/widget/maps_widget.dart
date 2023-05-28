import 'package:flutter/material.dart';
import 'package:todos/models/place_location_models.dart';
import 'package:todos/pages/screen/map_screen.dart';
import 'package:todos/services/place_location_service.dart';

class MapsWidget extends StatelessWidget {
  const MapsWidget(
      {super.key, required this.placeLocation, required this.setLocationFn});
  final PlaceLocation placeLocation;
  final Function(PlaceLocation placeLocation) setLocationFn;

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
              return MapsScreen(
                initialLocation: placeLocation,
                setLocationFn: setLocationFn,
              );
            },
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: previewMapsImageUrl.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Ketuk untuk tambahkan Lokasi',
                  ),
                ),
              )
            // Sudah berhasil, tpi kalau 0.0 kita dittengah laut
            : Stack(
                children: [
                  Image.network(
                    previewMapsImageUrl,
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        // Begini saja sudah auto kehapus
                        setLocationFn(
                          PlaceLocation(
                            latitude: 0.0,
                            longitude: 0.0,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
