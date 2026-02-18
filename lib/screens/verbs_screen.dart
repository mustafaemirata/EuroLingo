import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:eurolingo/theme/app_theme.dart';
import 'package:eurolingo/services/wallet_service.dart';
import 'package:eurolingo/screens/verb_detail_screen.dart';

class VerbsScreen extends StatefulWidget {
  final WalletService walletService;
  const VerbsScreen({super.key, required this.walletService});

  @override
  State<VerbsScreen> createState() => _VerbsScreenState();
}

class _VerbsScreenState extends State<VerbsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final FlutterTts _tts = FlutterTts();
  List<Map<String, dynamic>> _irregularVerbs = [];
  List<Map<String, dynamic>> _regularVerbs = [];
  bool _loading = true;

  final List<String> _alphabet = List.generate(
    26,
    (i) => String.fromCharCode(65 + i),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
    _loadVerbs();
    _initTts();
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
      setState(() {
        _irregularVerbs = List<Map<String, dynamic>>.from(
          json.decode(irregularJson),
        );
        _regularVerbs = List<Map<String, dynamic>>.from(
          json.decode(regularJson),
        );
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error loading verbs: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _speakLetter(String letter) async {
    try {
      await _tts.speak(letter);
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    try {
      _tts.stop();
    } catch (_) {}
    super.dispose();
  }

  Map<String, List<Map<String, dynamic>>> _getVerbsByLetter(
    List<Map<String, dynamic>> verbs,
  ) {
    final Map<String, List<Map<String, dynamic>>> map = {};
    for (final verb in verbs) {
      final v1 = (verb['V1'] ?? '').toString();
      if (v1.isNotEmpty) {
        final letter = v1[0].toUpperCase();
        map.putIfAbsent(letter, () => []);
        map[letter]!.add(verb);
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildTabBar(),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppTheme.primary),
                    )
                  : _buildLetterGrid(),
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
                  'Fiiller',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  _loading
                      ? 'Yükleniyor...'
                      : _tabController.index == 0
                      ? '${_irregularVerbs.length} düzensiz fiil'
                      : '${_regularVerbs.length} düzenli fiil',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
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
          indicatorSize: TabBarIndicatorSize.tab,
          padding: const EdgeInsets.all(3),
          tabs: [
            Tab(
              text: _loading
                  ? 'Düzensiz'
                  : 'Düzensiz (${_irregularVerbs.length})',
            ),
            Tab(
              text: _loading ? 'Düzenli' : 'Düzenli (${_regularVerbs.length})',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLetterGrid() {
    final verbs = _tabController.index == 0 ? _irregularVerbs : _regularVerbs;
    final isIrregular = _tabController.index == 0;
    final letterMap = _getVerbsByLetter(verbs);

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
        final verbsForLetter = letterMap[letter] ?? [];
        return _VerbLetterCard(
          letter: letter,
          verbCount: verbsForLetter.length,
          onTap: () {
            if (verbsForLetter.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VerbDetailScreen(
                    letter: letter,
                    verbs: verbsForLetter,
                    isIrregular: isIrregular,
                    walletService: widget.walletService,
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


class _VerbLetterCard extends StatefulWidget {
  final String letter;
  final int verbCount;
  final VoidCallback onTap;
  final VoidCallback onSpeakTap;
  final int animationDelay;

  const _VerbLetterCard({
    required this.letter,
    required this.verbCount,
    required this.onTap,
    required this.onSpeakTap,
    required this.animationDelay,
  });

  @override
  State<_VerbLetterCard> createState() => _VerbLetterCardState();
}

class _VerbLetterCardState extends State<_VerbLetterCard>
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
    final hasVerbs = widget.verbCount > 0;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: hasVerbs ? widget.onTap : null,
        onLongPress: hasVerbs ? widget.onSpeakTap : null,
        child: AnimatedScale(
          scale: _isPressed ? 0.93 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            decoration: BoxDecoration(
              gradient: hasVerbs
                  ? AppTheme.getLetterGradient(widget.letter.codeUnitAt(0) - 65)
                  : null,
              color: hasVerbs
                  ? null
                  : AppTheme.surfaceCard.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(14),
              border: hasVerbs
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
                    color: hasVerbs ? AppTheme.primary : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasVerbs ? '${widget.verbCount}' : '—',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: hasVerbs
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
