import 'package:session_server_client/api.dart';

class LocationModel {
  final int x;
  final int y;

  const LocationModel(this.x, this.y);

  factory LocationModel.fromDto(LocationDto dto) => LocationModel(dto.x!, dto.y!);

  LocationDto toDto() => LocationDto(x: x, y: y);
}
