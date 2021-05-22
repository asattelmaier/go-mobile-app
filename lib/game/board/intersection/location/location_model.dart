import 'package:go_app/game/client/common/location_dto.dart';

class LocationModel {
  final int x;
  final int y;

  const LocationModel(this.x, this.y);

  factory LocationModel.fromDto(LocationDto dto) => LocationModel(dto.x, dto.y);

  LocationDto toDto() => LocationDto(x, y);
}
