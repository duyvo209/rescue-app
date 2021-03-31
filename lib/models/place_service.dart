import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:google_place/google_place.dart';
import 'package:http/http.dart';
import 'package:rescue/configs/configs.dart';

class Place {
  String streetNumber;
  String street;
  String city;
  String zipCode;
  String fullAddress;
  double lat;
  double long;

  Place({
    this.streetNumber,
    this.street,
    this.city,
    this.zipCode,
    this.fullAddress,
    this.lat,
    this.long,
  });

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String androidKey = 'YOUR_API_KEY_HERE';
  static final String iosKey = 'AIzaSyBHRMxpBKc25CMHY51h1jrnCCm6PjNs62s';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:vn&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    var googlePlace = GooglePlace(GOOGLE_API_KEY);
    var result = await googlePlace.details.get(placeId);

    return Place(
        lat: result.result.geometry.location.lat,
        long: result.result.geometry.location.lng,
        fullAddress: result.result.addressComponents.first.longName,
        street: '',
        streetNumber: '');
  }
}
