import 'dart:math';
import 'package:flutter/material.dart';
import 'package:eurolingo/models/word_model.dart';
import 'package:eurolingo/theme/app_theme.dart';
import 'package:eurolingo/services/mistake_service.dart';

class QuizScreen extends StatefulWidget {
  final List<WordItem> words;
  final MistakeService mistakeService;

  const QuizScreen({
    super.key,
    required this.words,
    required this.mistakeService,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final Random _random = Random();
  late List<WordItem> _shuffledWords;
  int _currentIndex = 0;
  int _score = 0;
  List<String> _options = [];
  int _correctIndex = -1;
  int? _selectedIndex;
  bool _answered = false;
  bool _quizFinished = false;
  final List<_QuizResult> _results = [];

  @override
  void initState() {
    super.initState();
    _shuffledWords = List.from(widget.words)..shuffle(_random);
    _generateQuestion();
  }

  void _generateQuestion() {
    if (_currentIndex >= _shuffledWords.length) {
      setState(() => _quizFinished = true);
      return;
    }

    final currentWord = _shuffledWords[_currentIndex];
    final correctMeaning = currentWord.primaryMeaning;

    final otherWords =
        widget.words.where((w) => w.term != currentWord.term).toList()
          ..shuffle(_random);

    final wrongMeanings = <String>[];
    for (final w in otherWords) {
      if (wrongMeanings.length >= 3) break;
      final m = w.primaryMeaning;
      if (m != correctMeaning && !wrongMeanings.contains(m)) {
        wrongMeanings.add(m);
      }
    }

    _options = [...wrongMeanings, correctMeaning]..shuffle(_random);
    _correctIndex = _options.indexOf(correctMeaning);
    _selectedIndex = null;
    _answered = false;
    setState(() {});
  }

  void _selectOption(int index) {
    if (_answered) return;

    final word = _shuffledWords[_currentIndex];
    final isCorrect = index == _correctIndex;

    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (isCorrect) {
        _score++;
      } else {
        widget.mistakeService.addMistake(
          MistakeEntry(
            term: word.term,
            correctMeaning: word.primaryMeaning,
            userAnswer: _options[index],
          ),
        );
      }
      _results.add(
        _QuizResult(
          word: word,
          isCorrect: isCorrect,
          userAnswer: _options[index],
          correctAnswer: _options[_correctIndex],
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _currentIndex++;
          _generateQuestion();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizFinished) return _buildResultsScreen();

    final word = _shuffledWords[_currentIndex];
    final progress = (_currentIndex + 1) / _shuffledWords.length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildProgressBar(progress),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildQuestionCard(word),
                    const SizedBox(height: 20),
                    Expanded(child: _buildOptions()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showExitDialog(context),
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
            'Quiz',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1} / ${_shuffledWords.length}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
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

  Widget _buildQuestionCard(WordItem word) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
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
          const SizedBox(height: 16),
          Text(
            word.term,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _options.length,
      itemBuilder: (context, index) {
        final isSelected = _selectedIndex == index;
        final isCorrect = index == _correctIndex;
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      _options[index],
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
    );
  }

  
  Widget _buildResultsScreen() {
    final total = _results.length;
    final correct = _results.where((r) => r.isCorrect).length;
    final wrong = _results.where((r) => !r.isCorrect).length;
    final percentage = total > 0 ? (correct / total * 100).round() : 0;
    final isSuccess = percentage >= 70;

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
                    onTap: () => Navigator.pop(context),
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
                  Text(
                    isSuccess ? 'Tebrikler!' : 'Sonuçlar',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
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
                    Text(
                      '%$percentage',
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: isSuccess
                            ? AppTheme.accentGreen
                            : AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isSuccess
                          ? 'Harika iş çıkardınız!'
                          : 'Daha fazla çalışmaya ihtiyacınız var',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatBadge(
                          'Doğru',
                          '$correct',
                          AppTheme.accentGreen,
                        ),
                        const SizedBox(width: 20),
                        _buildStatBadge('Yanlış', '$wrong', AppTheme.errorRed),
                        const SizedBox(width: 20),
                        _buildStatBadge(
                          'Toplam',
                          '$total',
                          AppTheme.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Detaylı Sonuçlar',
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
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final result = _results[index];
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
                          result.isCorrect
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: result.isCorrect
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
                                result.word.term,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              if (result.isCorrect)
                                Text(
                                  result.correctAnswer,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textMuted,
                                  ),
                                )
                              else ...[
                                Text(
                                  'Cevabınız: ${result.userAnswer}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.errorRed,
                                  ),
                                ),
                                Text(
                                  'Doğru: ${result.correctAnswer}',
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
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Kapat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF121214),
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

  Widget _buildStatBadge(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
        ),
      ],
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Quiz'den Çık",
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Skorunuz: $_score / ${_results.length}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_shuffledWords.length - _currentIndex} soru kaldı',
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Devam Et',
              style: TextStyle(color: AppTheme.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Çık',
              style: TextStyle(
                color: AppTheme.errorRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizResult {
  final WordItem word;
  final bool isCorrect;
  final String userAnswer;
  final String correctAnswer;

  _QuizResult({
    required this.word,
    required this.isCorrect,
    required this.userAnswer,
    required this.correctAnswer,
  });
}
