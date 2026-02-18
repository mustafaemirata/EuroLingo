import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eurolingo/theme/app_theme.dart';
import 'package:eurolingo/services/duel_service.dart';
import 'package:eurolingo/screens/duel_result_screen.dart';

import 'package:eurolingo/services/mistake_service.dart';

class DuelGameScreen extends StatefulWidget {
  final String roomCode;
  final bool isHost;

  const DuelGameScreen({
    super.key,
    required this.roomCode,
    required this.isHost,
  });

  @override
  State<DuelGameScreen> createState() => _DuelGameScreenState();
}

class _DuelGameScreenState extends State<DuelGameScreen> {
  final DuelService _duelService = DuelService();
  final MistakeService _mistakeService = MistakeService();
  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  int _myScore = 0;
  int _opponentScore = 0;
  String _opponentName = '';
  String _myName = '';
  String? _myPhotoUrl;
  String? _opponentPhotoUrl;
  int? _selectedIndex;
  bool _answered = false;
  bool _quizFinished = false;
  bool _isLoading = true;
  StreamSubscription? _roomSubscription;
  final List<Map<String, dynamic>> _myResults = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    _roomSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    final doc = await FirebaseFirestore.instance
        .collection('duels')
        .doc(widget.roomCode)
        .get();

    if (!doc.exists || !mounted) return;

    final data = doc.data()!;
    final questions = List<Map<String, dynamic>>.from(data['questions']);

    setState(() {
      _questions = questions;
      _myName = widget.isHost
          ? data['hostUsername'] ?? 'Sen'
          : data['guestUsername'] ?? 'Sen';
      _opponentName = widget.isHost
          ? data['guestUsername'] ?? 'Rakip'
          : data['hostUsername'] ?? 'Rakip';
      _myPhotoUrl = widget.isHost
          ? data['hostPhotoUrl']
          : data['guestPhotoUrl'];
      _opponentPhotoUrl = widget.isHost
          ? data['guestPhotoUrl']
          : data['hostPhotoUrl'];
      _isLoading = false;
    });

    
    _roomSubscription = _duelService.listenToRoom(widget.roomCode).listen((
      snapshot,
    ) {
      final d = snapshot.data();
      if (d == null) return;

      if (mounted) {
        setState(() {
          _opponentScore = widget.isHost
              ? (d['guestScore'] ?? 0)
              : (d['hostScore'] ?? 0);

          
          if (widget.isHost) {
            _opponentPhotoUrl = d['guestPhotoUrl'];
          }
        });

        
        final bool isFinished =
            d['status'] == 'finished' ||
            (d['hostFinished'] == true && d['guestFinished'] == true);

        final bool hasTimestamps =
            d['hostFinishedAt'] != null && d['guestFinishedAt'] != null;

        if (isFinished && _quizFinished && hasTimestamps) {
          _roomSubscription?.cancel();
          _navigateToResults(d);
        }
      }
    });
  }

  void _selectOption(int index) {
    if (_answered || _quizFinished) return;

    final question = _questions[_currentIndex];
    final selectedAnswer = question['options'][index];
    final isCorrect = selectedAnswer == question['correctAnswer'];

    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (isCorrect) _myScore++;
      if (!isCorrect) {
        _mistakeService.addMistake(
          MistakeEntry(
            term: question['term'],
            correctMeaning: question['correctAnswer'],
            userAnswer: selectedAnswer,
          ),
        );
      }
    });

    _myResults.add({
      'term': question['term'],
      'userAnswer': selectedAnswer,
      'correctAnswer': question['correctAnswer'],
      'isCorrect': isCorrect,
    });

    
    _duelService.submitAnswer(
      roomCode: widget.roomCode,
      uid: _uid,
      questionIndex: _currentIndex,
      answer: selectedAnswer,
      isCorrect: isCorrect,
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      if (_currentIndex + 1 >= _questions.length) {
        setState(() => _quizFinished = true);
        _onQuizFinished();
      } else {
        setState(() {
          _currentIndex++;
          _selectedIndex = null;
          _answered = false;
        });
      }
    });
  }

  Future<void> _onQuizFinished() async {
    await _duelService.markFinished(widget.roomCode, _uid);

    
    final doc = await FirebaseFirestore.instance
        .collection('duels')
        .doc(widget.roomCode)
        .get();

    if (doc.exists && mounted) {
      final data = doc.data()!;
      final bool isFinished =
          data['status'] == 'finished' ||
          (data['hostFinished'] == true && data['guestFinished'] == true);

      final bool hasTimestamps =
          data['hostFinishedAt'] != null && data['guestFinishedAt'] != null;

      if (isFinished && hasTimestamps) {
        _roomSubscription?.cancel();
        _navigateToResults(data);
      }
    }
  }

  void _navigateToResults(Map<String, dynamic> data) {
    
    final hostTime = data['hostFinishedAt'] as Timestamp?;
    final guestTime = data['guestFinishedAt'] as Timestamp?;

    final myTime = widget.isHost ? hostTime?.toDate() : guestTime?.toDate();
    final opponentTime = widget.isHost
        ? guestTime?.toDate()
        : hostTime?.toDate();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DuelResultScreen(
          roomCode: widget.roomCode,
          isHost: widget.isHost,
          myName: _myName,
          opponentName: _opponentName,
          myPhotoUrl: _myPhotoUrl,
          opponentPhotoUrl: _opponentPhotoUrl,
          myScore: _myScore,
          opponentScore: widget.isHost
              ? (data['guestScore'] ?? 0)
              : (data['hostScore'] ?? 0),
          totalQuestions: _questions.length,
          myResults: _myResults,
          myFinishedAt: myTime,
          opponentFinishedAt: opponentTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      );
    }

    if (_quizFinished) {
      return _buildWaitingForOpponent();
    }

    final question = _questions[_currentIndex];
    final options = List<String>.from(question['options']);
    final correctAnswer = question['correctAnswer'] as String;
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            
            _buildHeader(),
            const SizedBox(height: 6),
            _buildProgressBar(progress),
            const SizedBox(height: 16),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.04),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Bu kelimenin Türkçe anlamı nedir?',
                      style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      question['term'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndex == index;
                  final isCorrect = options[index] == correctAnswer;
                  Color bgColor = AppTheme.surfaceCard;
                  Color borderColor = Colors.transparent;
                  Color textColor = AppTheme.textPrimary;

                  if (_answered) {
                    if (isCorrect) {
                      bgColor = AppTheme.accentGreen.withValues(alpha: 0.1);
                      borderColor = AppTheme.accentGreen.withValues(alpha: 0.4);
                      textColor = AppTheme.accentGreen;
                    } else if (isSelected && !isCorrect) {
                      bgColor = AppTheme.errorRed.withValues(alpha: 0.1);
                      borderColor = AppTheme.errorRed.withValues(alpha: 0.4);
                      textColor = AppTheme.errorRed;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () => _selectOption(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: _answered && isCorrect
                                    ? AppTheme.accentGreen
                                    : _answered && isSelected && !isCorrect
                                    ? AppTheme.errorRed
                                    : Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: _answered && (isCorrect || isSelected)
                                    ? Icon(
                                        isCorrect
                                            ? Icons.check_rounded
                                            : Icons.close_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : Text(
                                        String.fromCharCode(65 + index),
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                options[index],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildScoreChip(
                _myName,
                _myScore,
                AppTheme.primary,
                _myPhotoUrl,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1} / ${_questions.length}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildScoreChip(
                _opponentName,
                _opponentScore,
                AppTheme.textMuted,
                _opponentPhotoUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreChip(
    String name,
    int score,
    Color accent,
    String? photoUrl,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.2), width: 0.5),
      ),
      constraints: const BoxConstraints(minWidth: 80),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppTheme.background,
            backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                ? NetworkImage(photoUrl)
                : null,
            child: photoUrl == null || photoUrl.isEmpty
                ? Icon(Icons.person_rounded, color: accent, size: 14)
                : null,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
                Text(
                  '$score',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: AppTheme.surfaceCard,
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
          minHeight: 3,
        ),
      ),
    );
  }

  Widget _buildWaitingForOpponent() {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primary,
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Skorun: $_myScore / ${_questions.length}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Rakibin bitirmesi bekleniyor...',
              style: TextStyle(fontSize: 15, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
