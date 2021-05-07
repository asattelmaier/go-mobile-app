import 'package:go_app/api/game/common/location_dto.dart';
import 'package:go_app/api/game/common/state_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'intersection_dto.g.dart';

@JsonSerializable()
class IntersectionDto {
  final LocationDto location;
  final StateDto state;

  IntersectionDto(this.location, this.state);

  factory IntersectionDto.fromJson(Map<String, dynamic> json) =>
      _$IntersectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$IntersectionDtoToJson(this);
}