import 'package:session_server_client/api.dart';
import 'package:go_app/game/board/intersection/location/location_model.dart';
import 'package:go_app/game/board/intersection/state/state_model.dart';

class IntersectionModel {
  final LocationModel location;
  final StateModel state;

  const IntersectionModel(this.location, this.state);

  factory IntersectionModel.fromDto(IntersectionDto dto) => IntersectionModel(
      LocationModel.fromDto(dto.location!), StateModel.fromDto(dto.state!));

  IntersectionDto toDto() => IntersectionDto(location: location.toDto(), state: state.toDto());
}
