import 'package:flutter/material.dart';
import 'package:eurolingo/data/word_data.dart';
import 'package:eurolingo/models/word_model.dart';
import 'package:eurolingo/theme/app_theme.dart';
import 'package:eurolingo/screens/word_detail_screen.dart';
import 'package:eurolingo/services/wallet_service.dart';
import 'package:eurolingo/services/mistake_service.dart';

class LetterDetailScreen extends StatefulWidget {
  final String letter;
  final WalletService walletService;
  final MistakeService mistakeService;

  const LetterDetailScreen({
    super.key,
    required this.letter,
    required this.walletService,
    required this.mistakeService,
  });

  @override
  State<LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends State<LetterDetailScreen> {
  late List<WordItem> _allWords;
  List<WordItem> _filteredWords = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allWords = wordsByLetter[widget.letter] ?? [];
    _filteredWords = List.from(_allWords);
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredWords = List.from(_allWords);
      } else {
        _filteredWords = _allWords.where((word) {
          return word.term.toLowerCase().contains(query) ||
              word.meanings.any((m) => m.toLowerCase().contains(query));
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openWordDetail(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WordDetailScreen(
          words: _filteredWords,
          initialIndex: index,
          walletService: widget.walletService,
          mistakeService: widget.mistakeService,
          letter: widget.letter,
        ),
      ),
    ).then((_) => setState(() {}));
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
            _buildSearchBar(),
            const SizedBox(height: 8),
            Expanded(child: _buildWordList()),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.letter} Harfi',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '${_allWords.length} kelime',
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
        ],
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
            hintText: 'Kelime ara...',
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

  Widget _buildWordList() {
    if (_filteredWords.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 40, color: AppTheme.textMuted),
            SizedBox(height: 10),
            Text(
              'Kelime bulunamadı',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredWords.length,
      itemBuilder: (context, index) {
        final word = _filteredWords[index];
        return GestureDetector(
          onTap: () => _openWordDetail(index),
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
                      Text(
                        word.allMeanings,
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
                GestureDetector(
                  onTap: () {
                    widget.walletService.toggle(word.term);
                    setState(() {});
                  },
                  child: Icon(
                    widget.walletService.isSaved(word.term)
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: widget.walletService.isSaved(word.term)
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
}
