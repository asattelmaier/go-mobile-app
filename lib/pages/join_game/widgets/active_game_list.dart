import 'package:flutter/material.dart';
import 'package:go_app/game-session/client/game_session_client.dart';
import 'package:go_app/game-session/game_session_model.dart';
import 'package:go_app/theme/go_theme.dart';
import 'package:go_app/widgets/clay_card/clay_card.dart';

class ActiveGameList extends StatelessWidget {
  final List<GameSessionModel> gameSessions;
  final GameSessionClient gameSessionClient;

  const ActiveGameList({
    Key? key,
    required this.gameSessions,
    required this.gameSessionClient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (gameSessions.isEmpty) return SizedBox.shrink();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView.separated(
          itemCount: gameSessions.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final session = gameSessions[index];
            final hostName = session.players.isNotEmpty
                ? session.players.first.id
                : "Unknown";
            final theme = GoTheme.of(context);

            return GestureDetector(
              onTap: () {
                gameSessionClient.joinSession(session.id);
              },
              child: ClayCard(
                height: 80,
                borderRadius: 16,
                color: theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person,
                            color: theme.colorScheme.primary),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              hostName,
                              style: TextStyle(
                                fontFamily: theme.fontFamily,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "ID: ${session.id}",
                              style: TextStyle(
                                fontFamily: theme.fontFamily,
                                fontSize: 12,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
