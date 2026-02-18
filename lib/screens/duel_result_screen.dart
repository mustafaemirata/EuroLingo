import 'package:flutter/material.dart';
import 'package:eurolingo/theme/app_theme.dart';
import 'package:eurolingo/services/duel_service.dart';

class DuelResultScreen extends StatelessWidget {
  final String roomCode;
  final bool isHost;
  final String myName;
  final String opponentName;
  final String? myPhotoUrl;
  final String? opponentPhotoUrl;
  final int myScore;
  final int opponentScore;
  final int totalQuestions;
  final List<Map<String, dynamic>> myResults;
  final DateTime? myFinishedAt;
  final DateTime? opponentFinishedAt;

  const DuelResultScreen({
    super.key,
    required this.roomCode,
    required this.isHost,
    required this.myName,
    required this.opponentName,
    this.myPhotoUrl,
    this.opponentPhotoUrl,
    required this.myScore,
    required this.opponentScore,
    required this.totalQuestions,
    required this.myResults,
    this.myFinishedAt,
    this.opponentFinishedAt,
  });

  @override
  Widget build(BuildContext context) {
    bool isWin = myScore > opponentScore;
    bool isDraw = myScore == opponentScore;
    bool tieBrokenBySpeed = false;

    if (isDraw && myFinishedAt != null && opponentFinishedAt != null) {
      if (myFinishedAt!.isBefore(opponentFinishedAt!)) {
        isWin = true;
        isDraw = false;
        tieBrokenBySpeed = true;
      } else if (opponentFinishedAt!.isBefore(myFinishedAt!)) {
        isWin = false;
        isDraw = false;
        tieBrokenBySpeed = true;
      }
    }

    String resultText;
    Color resultColor;
    IconData resultIcon;

    if (isDraw) {
      resultText = 'Berabere!';
      resultColor = AppTheme.primary;
      resultIcon = Icons.handshake_rounded;
    } else if (isWin) {
      resultText = tieBrokenBySpeed ? 'Hızla Kazandın! 🎉' : 'Kazandın! 🎉';
      resultColor = AppTheme.accentGreen;
      resultIcon = Icons.emoji_events_rounded;
    } else {
      resultText = tieBrokenBySpeed ? 'Hızla Kaybettin' : 'Kaybettin';
      resultColor = AppTheme.errorRed;
      resultIcon = Icons.sentiment_dissatisfied_rounded;
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Düello Sonucu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: resultColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(resultIcon, size: 56, color: resultColor),
                    const SizedBox(height: 12),
                    Text(
                      resultText,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: resultColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildPlayerScore(
                            myName,
                            myScore,
                            isWin || isDraw
                                ? AppTheme.primary
                                : AppTheme.textMuted,
                            isWin,
                            myPhotoUrl,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'VS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildPlayerScore(
                            opponentName,
                            opponentScore,
                            !isWin && !isDraw
                                ? AppTheme.primary
                                : AppTheme.textMuted,
                            !isWin && !isDraw,
                            opponentPhotoUrl,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$totalQuestions soru',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Senin Cevapların',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: myResults.length,
                itemBuilder: (context, index) {
                  final result = myResults[index];
                  final isCorrect = result['isCorrect'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCorrect
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: isCorrect
                              ? AppTheme.accentGreen
                              : AppTheme.errorRed,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result['term'] as String,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              if (isCorrect)
                                Text(
                                  result['correctAnswer'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textMuted,
                                  ),
                                )
                              else ...[
                                Text(
                                  'Cevabın: ${result['userAnswer']}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.errorRed,
                                  ),
                                ),
                                Text(
                                  'Doğru: ${result['correctAnswer']}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.accentGreen,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () {
                  
                  DuelService().deleteRoom(roomCode);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Ana Sayfaya Dön',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerScore(
    String name,
    int score,
    Color accent,
    bool isWinner,
    String? photoUrl,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppTheme.background,
          backgroundImage: photoUrl != null && photoUrl.isNotEmpty
              ? NetworkImage(photoUrl)
              : null,
          child: photoUrl == null || photoUrl.isEmpty
              ? Icon(Icons.person_rounded, color: accent, size: 20)
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          '$score',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: accent,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            name,
            maxLines: 3,
            overflow: TextOverflow.visible,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
