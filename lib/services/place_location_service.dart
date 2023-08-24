// Kalau punya bisa di Cloud google, tpi harus berbayar
import 'dart:convert';

import 'package:location/location.dart';
import 'package:http/http.dart' as http;

const googleApiKey = 'AIzaSyDBxM8Pafxgmq3fKTEIa9CbNg6ju7sByi0';
// JANGAN LUPA TAMBAHKAN JUGA GOOGLE API KEY DI MANIFEST ANDROID DAN APP DELEGATE SWIFT

class LocationService {
  // Function untuk generate maps
  static String generateMapUrlImage(double latitude, double longitude) {
    // Kalau == 0 maka tidak akan muncul apa2 di halaman detail
    if (latitude == 0 || longitude == 0) {
      return '';
    } else {
      return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$latitude,$longitude&markers=color:green%7Clabel:G%7C$latitude,$longitude&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$googleApiKey';
    }
  }

  Future<LocationData?> getUserLocation() async {
    Location location = Location();
    // Cek serviceEnabled => apakah servicce dihidupkan
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // Jika tidak diizinkan
      serviceEnabled = await location.requestService();
      // Kalau misal masih tidak diizinkan maka di null saja
      if (!serviceEnabled) {
        return null;
      }
    }

    // Apakah diizinkan untuk ambil lokasi
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      // Kalau ditolak
      permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.denied) {
        return null;
      }
    }
    // ini untuk dpatkan lokasi user dari gps
    return location.getLocation();
  }

  // Fungsi untuk memberi tulisan alamat koordinat di appbar
  Future<String> getPlaceAddress(double latitude, double longitude) async {
    // url nya dari geocoding api google
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleApiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['results'].length > 0) {
        return result['results'][0]['formatted_address'];
      }
    }

    return '';
  }
}
