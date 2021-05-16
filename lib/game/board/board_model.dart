import 'package:go_app/game/board/intersection/intersection_model.dart';
import 'package:go_app/game/client/common/intersection_dto.dart';

class BoardModel {
  List<List<IntersectionModel>> intersections;

  BoardModel(this.intersections);

  BoardModel.empty() : this.intersections = [];

  factory BoardModel.fromDto(List<List<IntersectionDto>> dto) => BoardModel(dto
      .map((e) => e.map((e) => IntersectionModel.fromDto(e)).toList())
      .toList());

  List<List<IntersectionDto>> toDto() =>
      intersections.map((e) => e.map((e) => e.toDto()).toList()).toList();

  int get size => intersections.length;

  bool get isEmpty => size == 0;
}
