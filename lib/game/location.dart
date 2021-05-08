import 'package:go_app/api/game/common/location_dto.dart';

class Location {
  final int _x;
  final int _y;

  Location(this._x, this._y);

  factory Location.fromDto(LocationDto dto) => Location(dto.x, dto.y);

  LocationDto toDto() => LocationDto(_x, _y);
}
