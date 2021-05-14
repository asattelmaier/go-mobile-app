import 'package:go_app/api/game/common/location_dto.dart';

class LocationModel {
  final int _x;
  final int _y;

  LocationModel(this._x, this._y);

  factory LocationModel.fromDto(LocationDto dto) => LocationModel(dto.x, dto.y);

  LocationDto toDto() => LocationDto(_x, _y);
}
