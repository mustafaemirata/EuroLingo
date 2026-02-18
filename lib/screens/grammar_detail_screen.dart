import 'package:flutter/material.dart';
import 'package:eurolingo/theme/app_theme.dart';
import 'package:eurolingo/models/grammar_model.dart';
import 'package:eurolingo/screens/grammar_quiz_screen.dart';

class GrammarDetailScreen extends StatefulWidget {
  final GrammarTopic topic;

  const GrammarDetailScreen({super.key, required this.topic});

  @override
  State<GrammarDetailScreen> createState() => _GrammarDetailScreenState();
}

class _GrammarDetailScreenState extends State<GrammarDetailScreen> {
  late List<GrammarExample> _displayExamples;

  @override
  void initState() {
    super.initState();
    _prepareExamples();
  }

  void _prepareExamples() {
    
    final pool = List<GrammarExample>.from(widget.topic.examples)..shuffle();

    
    if (pool.length > 3) {
      _displayExamples = pool.sublist(0, 3);
    } else {
      _displayExamples = pool;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          widget.topic.title,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppTheme.primary),
            onPressed: () {
              setState(() {
                _prepareExamples();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Konu Özeti'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primary.withOpacity(0.1)),
              ),
              child: Text(
                widget.topic.explanation,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Örnekler'),
            ..._displayExamples.map((e) => _buildExampleCard(e)),
            if (widget.topic.quizQuestions.isNotEmpty) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GrammarQuizScreen(
                          title: '${widget.topic.title} Testi',
                          questions: widget.topic.quizQuestions,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Konu Testini Çöz',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildExampleCard(GrammarExample example) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            example.en,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            example.tr,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
          if (example.note != null) ...[
            const SizedBox(height: 8),
            Text(
              '• ${example.note}',
              style: const TextStyle(
                color: AppTheme.primary,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
