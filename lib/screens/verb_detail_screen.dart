import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:eurolingo/theme/app_theme.dart';
import 'package:eurolingo/services/wallet_service.dart';

class VerbDetailScreen extends StatefulWidget {
  final String letter;
  final List<Map<String, dynamic>> verbs;
  final bool isIrregular;
  final WalletService walletService;

  const VerbDetailScreen({
    super.key,
    required this.letter,
    required this.verbs,
    required this.isIrregular,
    required this.walletService,
  });

  @override
  State<VerbDetailScreen> createState() => _VerbDetailScreenState();
}

enum _VerbViewMode { list, card }

class _VerbDetailScreenState extends State<VerbDetailScreen> {
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _searchController = TextEditingController();
  late PageController _pageController;
  List<Map<String, dynamic>> _filteredVerbs = [];
  _VerbViewMode _viewMode = _VerbViewMode.card;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredVerbs = List.from(widget.verbs);
    _pageController = PageController();
    _searchController.addListener(_onSearch);
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.4);
    } catch (_) {}
  }

  Future<void> _speak(String text) async {
    try {
      await _tts.speak(text);
    } catch (_) {}
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredVerbs = List.from(widget.verbs);
      } else {
        _filteredVerbs = widget.verbs.where((v) {
          final v1 = (v['V1'] ?? '').toString().toLowerCase();
          final tr = (v['Turkish'] ?? '').toString().toLowerCase();
          return v1.contains(query) || tr.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    try {
      _tts.stop();
    } catch (_) {}
    super.dispose();
  }

  String _getV2(Map<String, dynamic> verb) {
    return (verb['V2'] ?? verb['V2_V3'] ?? '').toString();
  }

  String _getV3(Map<String, dynamic> verb) {
    return (verb['V3'] ?? verb['V2_V3'] ?? '').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (_viewMode == _VerbViewMode.card) _buildProgressIndicator(),
            if (_viewMode == _VerbViewMode.list) ...[
              const SizedBox(height: 8),
              _buildSearchBar(),
            ],
            const SizedBox(height: 8),
            Expanded(
              child: _viewMode == _VerbViewMode.list
                  ? _buildVerbList()
                  : _buildCardView(),
            ),
            if (_viewMode == _VerbViewMode.card) ...[
              _buildBottomControls(),
              const SizedBox(height: 12),
            ],
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
                Text(
                  _viewMode == _VerbViewMode.card
                      ? '${widget.isIrregular ? "Düzensiz" : "Düzenli"} Fiiller'
                      : '${widget.letter} Harfi',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  _viewMode == _VerbViewMode.card
                      ? '${_currentIndex + 1} / ${_filteredVerbs.length}'
                      : '${_filteredVerbs.length} fiil',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildViewToggleButton(
                  icon: Icons.list_rounded,
                  mode: _VerbViewMode.list,
                ),
                _buildViewToggleButton(
                  icon: Icons.view_carousel_rounded,
                  mode: _VerbViewMode.card,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton({
    required IconData icon,
    required _VerbViewMode mode,
  }) {
    final isSelected = _viewMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _viewMode = mode;
          if (mode == _VerbViewMode.card) {
            _pageController = PageController(initialPage: _currentIndex);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? const Color(0xFF121214) : AppTheme.textMuted,
        ),
      ),
    );
  }

  
  Widget _buildProgressIndicator() {
    double progress = _filteredVerbs.isEmpty
        ? 0
        : (_currentIndex + 1) / _filteredVerbs.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
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

  
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Fiil ara...',
            hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
            prefixIcon: const Icon(
              Icons.search,
              color: AppTheme.textMuted,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: AppTheme.textMuted,
                      size: 18,
                    ),
                    onPressed: () => _searchController.clear(),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  
  Widget _buildVerbList() {
    if (_filteredVerbs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 40, color: AppTheme.textMuted),
            SizedBox(height: 10),
            Text(
              'Fiil bulunamadı',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredVerbs.length,
      itemBuilder: (context, index) {
        final verb = _filteredVerbs[index];
        final v1 = (verb['V1'] ?? '').toString();
        final v2 = _getV2(verb);
        final v3 = _getV3(verb);
        final turkish = (verb['Turkish'] ?? '').toString();

        return GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = index;
              _viewMode = _VerbViewMode.card;
              _pageController = PageController(initialPage: index);
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _speak(v1),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      size: 16,
                      color: AppTheme.primary,
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
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        turkish,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      v2,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      v3,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    widget.walletService.toggle(v1.toLowerCase());
                    setState(() {});
                  },
                  child: Icon(
                    widget.walletService.isSaved(v1.toLowerCase())
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: widget.walletService.isSaved(v1.toLowerCase())
                        ? AppTheme.primary
                        : AppTheme.textMuted,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  
  Widget _buildCardView() {
    if (_filteredVerbs.isEmpty) {
      return const Center(
        child: Text(
          'Fiil bulunamadı',
          style: TextStyle(color: AppTheme.textMuted),
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: _filteredVerbs.length,
      onPageChanged: (index) {
        setState(() => _currentIndex = index);
      },
      itemBuilder: (context, index) {
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: _buildSwipeCard(_filteredVerbs[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwipeCard(Map<String, dynamic> verb) {
    final v1 = (verb['V1'] ?? '').toString();
    final v2 = _getV2(verb);
    final v3 = _getV3(verb);
    final turkish = (verb['Turkish'] ?? '').toString();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          GestureDetector(
            onTap: () => _speak(v1),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volume_up_rounded,
                color: AppTheme.primary,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          Text(
            v1,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.isIrregular ? 'Düzensiz Fiil' : 'Düzenli Fiil',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            turkish,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildFormRow('V1', v1, AppTheme.primary),
                Divider(
                  color: AppTheme.textMuted.withValues(alpha: 0.1),
                  height: 16,
                ),
                _buildFormRow('V2', v2, AppTheme.primary),
                Divider(
                  color: AppTheme.textMuted.withValues(alpha: 0.1),
                  height: 16,
                ),
                _buildFormRow('V3', v3, AppTheme.primary),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
        ],
      ),
    );
  }

  Widget _buildFormRow(String label, String value, Color color) {
    return GestureDetector(
      onTap: () => _speak(value),
      child: Row(
        children: [
          Icon(
            Icons.volume_up_rounded,
            size: 16,
            color: color.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          GestureDetector(
            onTap: _currentIndex > 0
                ? () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                color: _currentIndex > 0
                    ? AppTheme.textPrimary
                    : AppTheme.textMuted,
                size: 24,
              ),
            ),
          ),

          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _filteredVerbs.isNotEmpty
                  ? Builder(
                      builder: (context) {
                        final v1 = (_filteredVerbs[_currentIndex]['V1'] ?? '')
                            .toString()
                            .toLowerCase();
                        final isSaved = widget.walletService.isSaved(v1);
                        return GestureDetector(
                          onTap: () {
                            widget.walletService.toggle(v1);
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isSaved
                                  ? AppTheme.primary
                                  : AppTheme.surfaceCard,
                              borderRadius: BorderRadius.circular(14),
                              border: isSaved
                                  ? null
                                  : Border.all(
                                      color: AppTheme.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 1,
                                    ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isSaved
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  size: 18,
                                  color: isSaved
                                      ? const Color(0xFF121214)
                                      : AppTheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isSaved ? 'Kaydedildi' : 'Kaydet',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSaved
                                        ? const Color(0xFF121214)
                                        : AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          
          GestureDetector(
            onTap: _currentIndex < _filteredVerbs.length - 1
                ? () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: _currentIndex < _filteredVerbs.length - 1
                    ? AppTheme.textPrimary
                    : AppTheme.textMuted,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
