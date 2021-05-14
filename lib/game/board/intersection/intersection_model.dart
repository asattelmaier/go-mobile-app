import 'package:go_app/api/game/common/intersection_dto.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/board/intersection/state/state_model.dart';

class IntersectionModel {
  final LocationModel _location;
  final StateModel _state;

  IntersectionModel(this._location, this._state);

  factory IntersectionModel.fromDto(IntersectionDto dto) => IntersectionModel(
      LocationModel.fromDto(dto.location), StateModel.fromDto(dto.state));

  IntersectionDto toDto() => IntersectionDto(_location.toDto(), _state.toDto());
}
