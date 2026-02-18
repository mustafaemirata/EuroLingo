import 'package:flutter/material.dart';
import 'package:eurolingo/theme/app_theme.dart';
import 'package:eurolingo/models/grammar_model.dart';

class GrammarQuizScreen extends StatefulWidget {
  final String title;
  final List<GrammarQuizQuestion> questions;

  const GrammarQuizScreen({
    super.key,
    required this.title,
    required this.questions,
  });

  @override
  State<GrammarQuizScreen> createState() => _GrammarQuizScreenState();
}

class _GrammarQuizScreenState extends State<GrammarQuizScreen> {
  late List<GrammarQuizQuestion> _shuffledQuestions;
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _showFeedback = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _prepareQuestions();
  }

  void _prepareQuestions() {
    
    _shuffledQuestions = List.from(widget.questions)..shuffle();

    
    if (_shuffledQuestions.length > 10) {
      _shuffledQuestions = _shuffledQuestions.sublist(0, 10);
    }

    
    _shuffledQuestions = _shuffledQuestions.map((q) {
      final options = List<String>.from(q.options);
      final correctOption = options[q.correctIndex];
      options.shuffle();
      final newCorrectIndex = options.indexOf(correctOption);

      return GrammarQuizQuestion(
        question: q.question,
        options: options,
        correctIndex: newCorrectIndex,
        explanation: q.explanation,
      );
    }).toList();
  }

  void _handleOptionTap(int index) {
    if (_showFeedback) return;

    setState(() {
      _selectedIndex = index;
      _showFeedback = true;
      if (index == _shuffledQuestions[_currentIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _shuffledQuestions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _showFeedback = false;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        title: const Text(
          'Test Tamamlandı',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          'Skorunuz: $_score / ${_shuffledQuestions.length}',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
              Navigator.pop(context); 
            },
            child: const Text(
              'Kapat',
              style: TextStyle(color: AppTheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_shuffledQuestions.isEmpty) return const SizedBox.shrink();
    final question = _shuffledQuestions[_currentIndex];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _shuffledQuestions.length,
              backgroundColor: AppTheme.surfaceCard,
              color: AppTheme.primary,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                question.question,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  return _buildOptionCard(index, question);
                },
              ),
            ),
            if (_showFeedback)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentIndex < _shuffledQuestions.length - 1
                        ? 'Sonraki Soru'
                        : 'Sonuçları Gör',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(int index, GrammarQuizQuestion question) {
    final isSelected = _selectedIndex == index;
    final isCorrect = index == question.correctIndex;

    Color color = AppTheme.surfaceCard;
    if (_showFeedback) {
      if (isCorrect)
        color = Colors.green.withOpacity(0.2);
      else if (isSelected)
        color = Colors.red.withOpacity(0.2);
    } else if (isSelected) {
      color = AppTheme.primary.withOpacity(0.1);
    }

    return GestureDetector(
      onTap: () => _handleOptionTap(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _showFeedback && isCorrect
                ? Colors.green
                : (_showFeedback && isSelected
                      ? Colors.red
                      : AppTheme.primary.withOpacity(0.05)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question.options[index],
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (_showFeedback && isCorrect)
              const Icon(Icons.check_circle_rounded, color: Colors.green),
            if (_showFeedback && isSelected && !isCorrect)
              const Icon(Icons.cancel_rounded, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
