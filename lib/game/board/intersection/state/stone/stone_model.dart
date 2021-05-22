import 'package:go_app/game/player/player_color.dart';

class StoneModel {
  final PlayerColor color;

  const StoneModel(this.color);

  bool get isBlack => color == PlayerColor.Black;

  bool get isWhite => color == PlayerColor.White;
}
