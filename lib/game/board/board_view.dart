import 'package:flutter/material.dart';
import 'package:go_app/game/board/board_controller.dart';
import 'package:go_app/game/board/intersection/intersection_controller.dart';
import 'package:go_app/game/board/intersection/intersection_view.dart';
import 'package:go_app/theme/go_theme.dart';

class BoardView extends StatelessWidget {
  // TODO(theme): Centralize border width and colors in GoTheme.
  final BoardController _controller;

  const BoardView(this._controller);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);

    if (_controller.isBoardEmpty) {
      return Container();
    }

    return LayoutBuilder(builder: (context, constraints) {
      final size = constraints.maxWidth;
      
      return Container(
        // The container fills the LayoutBuilder parent (which is the ClayCard inner padding)
        child: Container(
          child: Padding(
              padding: EdgeInsets.all(theme.gutter * 2),
              child: Stack(children: [
                _createGrid(theme, size - (theme.gutter * 4)), // Adjust size for padding
                _intersections,
              ])),
        ),
      );
    });
  }

  // TODO(rendering): Refactor grid rendering to support rounded edges and advanced shadow effects (Claymorphism).
  Widget _createGrid(GoTheme theme, double gridSize) => Center(
      child: Padding(
          padding: EdgeInsets.all(gridSize / _controller.size / 2),
          child: Stack(
            children: [
              _createVerticalLines(theme),
              _createHorizontalLines(theme),
            ],
          )));

  Widget get _intersections => Row(
        children: _controller.intersections
            .map((intersections) => Flexible(
                child: Column(
                    children: intersections
                        .map((intersection) => IntersectionView(
                              IntersectionController(_controller, intersection),
                            ))
                        .toList())))
            .toList(),
      );

  Widget _createVerticalLines(GoTheme theme) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _createLines(Flexible(
            child: Container(
          width: 4.0,
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(2.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                offset: Offset(-1, -1),
                blurRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(1, 1),
                blurRadius: 1,
              ),
            ],
          ),
        ))),
      );

  Widget _createHorizontalLines(GoTheme theme) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _createLines(Flexible(
            child: Container(
          height: 4.0,
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(2.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                offset: Offset(-1, -1),
                blurRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(1, 1),
                blurRadius: 1,
              ),
            ],
          ),
        ))),
      );

  List<Widget> _createLines(Widget widget) =>
      List.generate(_controller.size, (_) => widget);
}
