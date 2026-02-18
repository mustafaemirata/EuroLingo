import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:eurolingo/data/word_data.dart';
import 'package:eurolingo/data/word_data_b2.dart';
import 'package:eurolingo/data/oxford_data.dart';
import 'package:eurolingo/models/word_model.dart';
import 'package:eurolingo/theme/app_theme.dart';
import 'package:eurolingo/services/wallet_service.dart';
import 'package:eurolingo/services/mistake_service.dart';
import 'package:eurolingo/screens/quiz_screen.dart';

class WalletScreen extends StatefulWidget {
  final WalletService walletService;
  final MistakeService mistakeService;

  const WalletScreen({
    super.key,
    required this.walletService,
    required this.mistakeService,
  });

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final FlutterTts _tts = FlutterTts();
  List<Map<String, dynamic>> _irregularVerbs = [];
  List<Map<String, dynamic>> _regularVerbs = [];
  bool _verbsLoading = true;
  bool _isCardView = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initTts();
    _loadVerbs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.4);
    } catch (_) {}
  }

  Future<void> _loadVerbs() async {
    try {
      final irregularJson = await rootBundle.loadString(
        'assets/irregular.json',
      );
      final regularJson = await rootBundle.loadString('assets/regular.json');
      if (mounted) {
        setState(() {
          _irregularVerbs = List<Map<String, dynamic>>.from(
            json.decode(irregularJson),
          );
          _regularVerbs = List<Map<String, dynamic>>.from(
            json.decode(regularJson),
          );
          _verbsLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading verbs in wallet: $e');
      if (mounted) setState(() => _verbsLoading = false);
    }
  }

  Future<void> _speak(String text) async {
    try {
      await _tts.speak(text);
    } catch (_) {}
  }

  List<WordItem> _getSavedWords() {
    final all = [...allWords, ...allWordsB2];
    final savedTerms = widget.walletService.savedTerms;
    final List<WordItem> result = [];

    for (final term in savedTerms) {
      
      try {
        final staticWord = all.firstWhere(
          (w) => w.term.toLowerCase() == term.toLowerCase(),
        );
        result.add(staticWord);
        continue;
      } catch (_) {}

      
      if (widget.walletService.customDefinitions.containsKey(term)) {
        final meanings = widget.walletService.customDefinitions[term]!;
        
        String displayTerm = term;
        if (term.isNotEmpty) {
          displayTerm = term[0].toUpperCase() + term.substring(1);
        }
        result.add(WordItem(displayTerm, meanings));
        continue;
      }

      
      bool isIrregular = false;
      try {
        _irregularVerbs.firstWhere(
          (v) => (v['V1'] ?? '').toString().toLowerCase() == term.toLowerCase(),
        );
        isIrregular = true;
      } catch (_) {}

      if (isIrregular) continue; 

      
      bool isRegular = false;
      try {
        _regularVerbs.firstWhere(
          (v) => (v['V1'] ?? '').toString().toLowerCase() == term.toLowerCase(),
        );
        isRegular = true;
      } catch (_) {}

      if (isRegular) continue; 

      
      String displayTerm = term;
      if (term.isNotEmpty) {
        displayTerm = term[0].toUpperCase() + term.substring(1);
      }
      result.add(WordItem(displayTerm, ['Özel Kelime']));
    }

    return result.reversed.toList();
  }

  List<Map<String, dynamic>> _getSavedVerbsOnly() {
    if (_verbsLoading) return [];
    final saved = widget.walletService.savedTerms.toList().reversed;
    final List<Map<String, dynamic>> result = [];

    for (final term in saved) {
      
      try {
        final irregular = _irregularVerbs.firstWhere(
          (v) => (v['V1'] ?? '').toString().toLowerCase() == term,
        );
        result.add(irregular);
        continue;
      } catch (_) {}

      
      try {
        final regular = _regularVerbs.firstWhere(
          (v) => (v['V1'] ?? '').toString().toLowerCase() == term,
        );
        result.add(regular);
        continue;
      } catch (_) {}
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildTabBar(),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSavedWordsTab(),
                  _buildMistakesTab(),
                  _buildVerbsTab(),
                ],
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
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cüzdanım',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                ListenableBuilder(
                  listenable: widget.walletService,
                  builder: (context, _) {
                    final count = _getSavedWords().length;
                    return Text(
                      '$count kelime kaydedildi',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          labelColor: const Color(0xFF121214),
          unselectedLabelColor: AppTheme.textMuted,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          dividerColor: Colors.transparent,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorSize: TabBarIndicatorSize.tab,
          padding: const EdgeInsets.all(3),
          tabs: [
            const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_rounded, size: 16),
                  SizedBox(width: 6),
                  Text('Kaydedilenler'),
                ],
              ),
            ),
            Tab(
              child: ListenableBuilder(
                listenable: widget.mistakeService,
                builder: (context, _) {
                  final count = widget.mistakeService.uniqueMistakes.length;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.close_rounded, size: 16),
                      const SizedBox(width: 4),
                      Text(count > 0 ? '($count)' : 'Yanlışlar'),
                    ],
                  );
                },
              ),
            ),
            const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_stories_rounded, size: 16),
                  SizedBox(width: 4),
                  Text('Fiiller'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedWordsTab() {
    return ListenableBuilder(
      listenable: widget.walletService,
      builder: (context, _) {
        final savedWords = _getSavedWords();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  
                  GestureDetector(
                    onTap: () => setState(() => _isCardView = !_isCardView),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _isCardView
                            ? Icons.list_alt_rounded
                            : Icons.view_carousel_rounded,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  if (savedWords.length >= 4)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                words: savedWords,
                                mistakeService: widget.mistakeService,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.quiz_rounded,
                                color: Color(0xFF121214),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Quiz Başlat',
                                style: TextStyle(
                                  color: Color(0xFF121214),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${savedWords.length}',
                                  style: const TextStyle(
                                    color: Color(0xFF121214),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                ],
              ),
            ),
            Expanded(
              child: _isCardView
                  ? _buildSavedWordsCards(savedWords)
                  : _buildSavedWordsList(savedWords),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSavedWordsCards(List<WordItem> savedWords) {
    if (savedWords.isEmpty) return _buildSavedWordsList(savedWords);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: savedWords.length,
        itemBuilder: (context, index) {
          final word = savedWords[index];
          
          final oxfordEntry =
              oxfordDataAll[word.term.toLowerCase()] ?? const OxfordEntry();

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () => _speak(word.term),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: AppTheme.primary,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  word.term,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                    height: 1.1,
                  ),
                ),
                if (oxfordEntry.pronunciation.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    oxfordEntry.pronunciation,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textMuted,
                      fontFamily: 'Courier',
                    ),
                  ),
                ],

                
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Türkçe Anlamları',
                                style: TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...word.meanings.take(3).indexed.map((e) {
                                final i = e.$1 + 1;
                                final mean = e.$2;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppTheme.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          '$i',
                                          style: const TextStyle(
                                            color: AppTheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          mean,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: AppTheme.textSecondary,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        
                        if (oxfordEntry.examples.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Örnek Cümleler',
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  children: [
                                    for (
                                      int i = 0;
                                      i < oxfordEntry.examples.length && i < 2;
                                      i++
                                    )
                                      Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.05,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => _speak(
                                                    oxfordEntry.examples[i],
                                                  ),
                                                  child: const Icon(
                                                    Icons.volume_up_rounded,
                                                    size: 16,
                                                    color: AppTheme.primary,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    oxfordEntry.examples[i],
                                                    style: const TextStyle(
                                                      color: AppTheme
                                                          .textSecondary,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (i <
                                                oxfordEntry
                                                    .translations
                                                    .length) ...[
                                              const SizedBox(height: 6),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 24,
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .arrow_right_alt_rounded,
                                                      size: 14,
                                                      color: AppTheme.primary,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        oxfordEntry
                                                            .translations[i],
                                                        style: const TextStyle(
                                                          color:
                                                              AppTheme.primary,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 16,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            widget.walletService.toggle(word.term);
                            setState(() {}); 
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${word.term} cüzdandan çıkarıldı',
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bookmark_remove_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Cüzdandan Çıkar',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSavedWordsList(List<WordItem> savedWords) {
    if (savedWords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bookmark_border_rounded,
              size: 48,
              color: AppTheme.textMuted,
            ),
            const SizedBox(height: 12),
            const Text(
              'Henüz kelime kaydetmediniz',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Kelimeleri kaydederek burada toplayın',
              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: savedWords.length,
      itemBuilder: (context, index) {
        final word = savedWords[index];
        return Dismissible(
          key: Key(word.term),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            widget.walletService.toggle(word.term);
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${word.term} çıkarıldı'),
                backgroundColor: AppTheme.surfaceCard,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            );
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: AppTheme.errorRed.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.delete_rounded,
              color: AppTheme.errorRed,
              size: 22,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.term,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: word.meanings
                            .take(3)
                            .map(
                              (tr) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.background.withValues(
                                    alpha: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  tr,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMistakesTab() {
    return ListenableBuilder(
      listenable: widget.mistakeService,
      builder: (context, _) {
        final mistakes = widget.mistakeService.uniqueMistakes;
        if (mistakes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 48,
                  color: AppTheme.accentGreen.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Henüz yanlışınız yok!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Quiz\'de yanlış yaptığınız kelimeler burada görünecek',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () => _showClearMistakesDialog(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_sweep_rounded,
                        color: AppTheme.errorRed,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Tümünü Temizle',
                        style: TextStyle(
                          color: AppTheme.errorRed,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: mistakes.length,
                itemBuilder: (context, index) {
                  final mistake = mistakes[index];
                  return Dismissible(
                    key: Key('mistake_${mistake.term}_$index'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) =>
                        widget.mistakeService.removeMistake(mistake.term),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.delete_rounded,
                        color: AppTheme.errorRed,
                        size: 22,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.04),
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _speak(mistake.term),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.volume_up_rounded,
                                    color: AppTheme.primary,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  mistake.term,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.background.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      size: 16,
                                      color: AppTheme.accentGreen,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        mistake.correctMeaning,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.accentGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.cancel_rounded,
                                      size: 16,
                                      color: AppTheme.errorRed,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        mistake.userAnswer,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.textMuted.withValues(
                                            alpha: 0.8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVerbsTab() {
    final savedVerbs = _getSavedVerbsOnly();
    if (savedVerbs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_stories_rounded,
              size: 48,
              color: AppTheme.textMuted,
            ),
            const SizedBox(height: 12),
            const Text(
              'Henüz fiil kaydetmediniz',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Fiilleri öğrenirken kaydederek burada görebilirsiniz',
              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: savedVerbs.length,
      itemBuilder: (context, index) {
        final verb = savedVerbs[index];
        final v1 = verb['V1'] ?? '';
        final v2 = verb['V2'] ?? verb['V2_V3'] ?? '';
        final v3 = verb['V3'] ?? verb['V2_V3'] ?? '';
        final turkish = verb['Turkish'] ?? '';

        return Dismissible(
          key: Key('verb_$v1'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            widget.walletService.toggle(v1);
            setState(() {});
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppTheme.errorRed.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.delete_rounded,
              color: AppTheme.errorRed,
              size: 22,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.04),
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _speak(v1),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.volume_up_rounded,
                          color: AppTheme.primary,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            v1,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            turkish,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textMuted,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildVerbFormCard('V1', v1, onSpeak: () => _speak(v1)),
                    const SizedBox(width: 8),
                    _buildVerbFormCard('V2', v2, onSpeak: () => _speak(v2)),
                    const SizedBox(width: 8),
                    _buildVerbFormCard('V3', v3, onSpeak: () => _speak(v3)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerbFormCard(
    String label,
    String form, {
    VoidCallback? onSpeak,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onSpeak,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: AppTheme.background.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppTheme.primary.withValues(alpha: 0.05),
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.volume_up_rounded,
                    size: 10,
                    color: AppTheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                form,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearMistakesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Tümünü Temizle',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        content: const Text(
          'Tüm yanlış cevapları silmek istediğinize emin misiniz?',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'İptal',
              style: TextStyle(color: AppTheme.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.mistakeService.clearAll();
              Navigator.pop(context);
            },
            child: const Text(
              'Temizle',
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
