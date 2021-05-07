import 'package:go_app/api/game/input/location_dto.dart';
import 'package:go_app/api/game/input/state_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'intersection_dto.g.dart';

@JsonSerializable(createToJson: false)
class IntersectionDto {
  final LocationDto location;
  final StateDto state;

  IntersectionDto(this.location, this.state);

  factory IntersectionDto.fromJson(Map<String, dynamic> json) =>
      _$IntersectionDtoFromJson(json);
}