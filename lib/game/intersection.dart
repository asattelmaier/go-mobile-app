import 'package:go_app/api/game/common/intersection_dto.dart';
import 'package:go_app/game/location.dart';
import 'package:go_app/game/state.dart';

class Intersection {
  final Location _location;
  final State _state;

  Intersection(this._location, this._state);

  factory Intersection.fromDto(IntersectionDto dto) =>
      Intersection(Location.fromDto(dto.location), State.fromDto(dto.state));

  IntersectionDto toDto() => IntersectionDto(_location.toDto(), _state.toDto());
}
