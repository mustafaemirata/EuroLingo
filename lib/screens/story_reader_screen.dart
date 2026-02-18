import 'package:flutter/material.dart';
import 'package:eurolingo/theme/app_theme.dart';
import 'package:eurolingo/services/wallet_service.dart';

class StoryReaderScreen extends StatefulWidget {
  final Map<String, dynamic> storyData;
  final WalletService walletService;

  const StoryReaderScreen({
    super.key,
    required this.storyData,
    required this.walletService,
  });

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  late List<dynamic> _sentences;
  late Map<String, dynamic> _dictionary;
  late Set<String> _highlightedWords;
  late String _title;
  int? _activeSentenceIndex;

  @override
  void initState() {
    super.initState();
    _title = widget.storyData['title'] ?? 'Story';
    _dictionary =
        widget.storyData['dict'] ?? widget.storyData['dictionary'] ?? {};

    
    final highlights = widget.storyData['highlighted_words'] as List<dynamic>?;
    _highlightedWords =
        highlights?.map((e) => e.toString().toLowerCase()).toSet() ?? {};

    _sentences = widget.storyData['sentences'] ?? [];
  }

  void _onWordTap(String word) {
    
    final cleanWord = word
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s\d]'), '')
        .trim();
    final translation = _dictionary[cleanWord];
    _showTranslationSheet(word, cleanWord, translation);
  }

  void _showTranslationSheet(
    String originalWord,
    String cleanWord,
    String? translation,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  originalWord,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              translation ?? 'Anlam bulunamadı',
              style: const TextStyle(
                fontSize: 18,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (translation != null) {
                    widget.walletService.toggle(
                      cleanWord,
                      meanings: [translation],
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$originalWord kaydedildi')),
                    );
                  }
                },
                icon: const Icon(
                  Icons.bookmark_add_rounded,
                  color: Colors.black,
                ),
                label: const Text(
                  'Kelimelerime Ekle',
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
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              color: AppTheme.primary.withOpacity(0.8),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'İpucu: Kelimelere veya cümlelere dokunarak çevirilerini görebilirsiniz!',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _sentences.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(top: 100),
                              child: Center(
                                child: Text(
                                  'Hikaye içeriği yüklenemedi.\nLütfen tekrar deneyin.',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Wrap(
                              spacing: 0,
                              runSpacing: 18,
                              children: _sentences.asMap().entries.map((entry) {
                                final index = entry.key;
                                final sentenceData = entry.value;
                                final en = (sentenceData['en'] ?? '') as String;
                                final isActive = _activeSentenceIndex == index;

                                if (en.isEmpty) return const SizedBox.shrink();

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _activeSentenceIndex = index;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? AppTheme.primary.withOpacity(0.15)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isActive
                                            ? AppTheme.primary.withOpacity(0.3)
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: en.split(' ').map((word) {
                                        final cleanWord = word
                                            .toLowerCase()
                                            .replaceAll(RegExp(r'[^\w]'), '')
                                            .trim();
                                        
                                        
                                        
                                        
                                        final isHighlighted = _highlightedWords
                                            .contains(cleanWord);

                                        return GestureDetector(
                                          onTap: () => _onWordTap(word),
                                          child: Text(
                                            word,
                                            style: TextStyle(
                                              fontSize: 20,
                                              height: 1.5,
                                              fontWeight: isHighlighted
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: isHighlighted
                                                  ? AppTheme.primary
                                                  : AppTheme.textPrimary
                                                        .withOpacity(0.9),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              ),
              if (_activeSentenceIndex != null) _buildTranslationBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTranslationBar() {
    final tr = _sentences[_activeSentenceIndex!]['tr'];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Çeviri',
            style: TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: AppTheme.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              _title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
