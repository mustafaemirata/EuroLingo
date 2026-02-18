import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:eurolingo/data/word_data.dart';
import 'package:eurolingo/data/word_data_b2.dart';
import 'package:eurolingo/models/word_model.dart';
import 'package:eurolingo/theme/app_theme.dart';
import 'package:eurolingo/screens/word_detail_screen.dart';
import 'package:eurolingo/screens/wallet_screen.dart';
import 'package:eurolingo/screens/verbs_screen.dart';
import 'package:eurolingo/services/wallet_service.dart';
import 'package:eurolingo/services/mistake_service.dart';
import 'package:eurolingo/screens/profile_screen.dart';
import 'package:eurolingo/screens/duel_lobby_screen.dart';
import 'package:eurolingo/screens/story_screen.dart';
import 'package:eurolingo/screens/grammar_screen.dart';

class HomeScreen extends StatefulWidget {
  final WalletService walletService;
  final MistakeService mistakeService;

  const HomeScreen({
    super.key,
    required this.walletService,
    required this.mistakeService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String? _selectedLevel;

  final List<String> _alphabet = List.generate(
    26,
    (i) => String.fromCharCode(65 + i),
  );

  @override
  void initState() {
    super.initState();
    _initTts();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.4);
    } catch (_) {}
  }

  @override
  void dispose() {
    _fadeController.dispose();
    try {
      _tts.stop();
    } catch (_) {}
    super.dispose();
  }

  Future<void> _speakLetter(String letter) async {
    try {
      await _tts.speak(letter);
    } catch (_) {}
  }

  List<WordItem> _getWordsForLevel() {
    return _selectedLevel == 'B2' ? allWordsB2 : allWords;
  }

  Map<String, List<WordItem>> _getWordsByLetterForLevel() {
    return _selectedLevel == 'B2' ? wordsByLetterB2 : wordsByLetter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _selectedLevel == null
              ? _buildCategoryScreen()
              : _buildLetterGridScreen(),
        ),
      ),
    );
  }

  
  Widget _buildCategoryScreen() {
    return Column(
      children: [
        _buildMainHeader(),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Text(
                  'Seviye Seçin',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Hangi seviyede çalışmak istiyorsunuz?',
                  style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 28),
                _buildLevelCard(
                  level: 'B1',
                  title: 'B1 — Orta Seviye',
                  subtitle: '${allWords.length} kelime',
                  description: 'Günlük konuşma ve temel iletişim',
                ),
                const SizedBox(height: 12),
                _buildLevelCard(
                  level: 'B2',
                  title: 'B2 — Üst Orta Seviye',
                  subtitle: '${allWordsB2.length} kelime',
                  description: 'İleri düzey okuma ve akademik İngilizce',
                ),
                const SizedBox(height: 28),
                Container(
                  height: 0.5,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Dilbilgisi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildNavigationCard(
                  icon: Icons.auto_stories_rounded,
                  title: 'Fiiller (Verbs)',
                  subtitle: 'Düzensiz & Düzenli Fiiller',
                  description: 'V1, V2, V3 formlarını öğrenin',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VerbsScreen(walletService: widget.walletService),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildNavigationCard(
                  icon: Icons.flash_on_rounded,
                  title: 'Online Düello',
                  subtitle: 'Arkadaşınla Yarış',
                  description: 'Arkadaşınla kelime düellosu yap',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DuelLobbyScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildNavigationCard(
                  icon: Icons.school_rounded,
                  title: 'Dilbilgisi (Grammar)',
                  subtitle: 'B1 & B2 Konu Anlatımları',
                  description: 'Temel ve ileri düzey gramer kuralları',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GrammarScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildNavigationCard(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Hikaye Modu',
                  subtitle: 'Gemini AI Destekli',
                  description: 'Kategorini seç, AI senin için hikaye yazsın',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StoryScreen(walletService: widget.walletService),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCard({
    required String level,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedLevel = level);
        _fadeController.reset();
        _fadeController.forward();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  level,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildNavigationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF121214), size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildMainHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          if (_selectedLevel != null)
            GestureDetector(
              onTap: () {
                setState(() => _selectedLevel = null);
                _fadeController.reset();
                _fadeController.forward();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/appicon.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'E',
                      style: TextStyle(
                        color: Color(0xFF121214),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EuroLingo',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  _selectedLevel != null
                      ? '$_selectedLevel · ${_getWordsForLevel().length} kelime'
                      : '${allWords.length + allWordsB2.length} kelime',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          ListenableBuilder(
            listenable: widget.walletService,
            builder: (context, _) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WalletScreen(
                        walletService: widget.walletService,
                        mistakeService: widget.mistakeService,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bookmark_rounded,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                      if (widget.walletService.savedWordsCount > 0) ...[
                        const SizedBox(width: 6),
                        Text(
                          '${widget.walletService.savedWordsCount}',
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppTheme.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildLetterGridScreen() {
    return Column(
      children: [
        _buildMainHeader(),
        const SizedBox(height: 8),
        Expanded(child: _buildLetterGrid()),
      ],
    );
  }

  Widget _buildLetterGrid() {
    final letterMap = _getWordsByLetterForLevel();
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _alphabet.length,
      itemBuilder: (context, index) {
        final letter = _alphabet[index];
        final words = letterMap[letter] ?? [];
        return _LetterCard(
          letter: letter,
          wordCount: words.length,
          onTap: () {
            if (words.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WordDetailScreen(
                    words: words,
                    initialIndex: 0,
                    walletService: widget.walletService,
                    mistakeService: widget.mistakeService,
                    letter: letter,
                  ),
                ),
              );
            }
          },
          onSpeakTap: () => _speakLetter(letter),
          animationDelay: index * 30,
        );
      },
    );
  }
}

class _LetterCard extends StatefulWidget {
  final String letter;
  final int wordCount;
  final VoidCallback onTap;
  final VoidCallback onSpeakTap;
  final int animationDelay;

  const _LetterCard({
    required this.letter,
    required this.wordCount,
    required this.onTap,
    required this.onSpeakTap,
    required this.animationDelay,
  });

  @override
  State<_LetterCard> createState() => _LetterCardState();
}

class _LetterCardState extends State<_LetterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasWords = widget.wordCount > 0;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: hasWords ? widget.onTap : null,
        onLongPress: hasWords ? widget.onSpeakTap : null,
        child: AnimatedScale(
          scale: _isPressed ? 0.93 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            decoration: BoxDecoration(
              gradient: hasWords
                  ? AppTheme.getLetterGradient(widget.letter.codeUnitAt(0) - 65)
                  : null,
              color: hasWords
                  ? null
                  : AppTheme.surfaceCard.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(14),
              border: hasWords
                  ? Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.08),
                      width: 0.5,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.letter,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: hasWords ? AppTheme.primary : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasWords ? '${widget.wordCount}' : '—',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: hasWords
                        ? AppTheme.textSecondary
                        : AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
