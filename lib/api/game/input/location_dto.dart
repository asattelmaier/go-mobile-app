import 'package:json_annotation/json_annotation.dart';

part 'location_dto.g.dart';

@JsonSerializable(createToJson: false)
class LocationDto {
  final int x;
  final int y;

  LocationDto(this.x, this.y);

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);
}