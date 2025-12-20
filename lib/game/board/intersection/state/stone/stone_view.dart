import 'package:flutter/material.dart';
import 'package:go_app/game/board/intersection/state/stone/stone_controller.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/clay_card/clay_card.dart';

class StoneView extends StatelessWidget {
  final StoneController _controller;

  const StoneView(this._controller);

  @override
  Widget build(BuildContext context) {
    final theme = GoTheme.of(context);
    final isBlack = _controller.isBlack;
    // Use the theme colors which are now updated (Teal/Orange)
    final baseColor = isBlack ? theme.blackStoneColor : theme.whiteStoneColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          // TODO(visuals): Implement sophisticated drop shadow using ClayPaintingMixin logic.
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: Offset(2, 3),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: ClayCard(
        borderRadius: 100,
        color: baseColor,
        isPressed: false,
        hasDropShadow: false,
        child: SizedBox(),
      ),
    );
  }
}
