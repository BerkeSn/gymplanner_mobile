// models/lat_lng_dto.dart

import 'package:gymplanner_mobile/features/walk_tracking/domain/entites/lat_lng_entity.dart';

class LatLngDto {
  final double lat;
  final double lng;
  LatLngDto({
    required this.lat,
    required this.lng,
  });

  factory LatLngDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return LatLngDto(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
  };

  LatLngEntity toEntity() =>
      LatLngEntity(lat: lat, lng: lng);
}
