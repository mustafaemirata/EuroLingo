import 'dart:async';
import 'package:flutter/material.dart';
import 'package:eurolingo/theme/app_theme.dart';
import 'package:eurolingo/services/gemini_service.dart';
import 'package:eurolingo/services/wallet_service.dart';
import 'package:eurolingo/screens/story_reader_screen.dart';

class StoryScreen extends StatefulWidget {
  final WalletService walletService;

  const StoryScreen({super.key, required this.walletService});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final GeminiService _geminiService = GeminiService();
  String _selectedLevel = 'B1';
  String _selectedCategory = 'Mixed';
  bool _isLoading = false;

  Timer? _loadingTimer;
  int _currentFactIndex = 0;

  final List<String> _loadingFacts = [
    "🇬🇧 'The quick brown fox jumps over the lazy dog' cümlesi İngilizcedeki tüm harfleri içerir.",
    "🗣️ İngilizcede en çok kullanılan harf 'E', en az kullanılan ise 'Q' harfidir.",
    "🍰 'Piece of cake' deyimi, 'Çocuk oyuncağı' (çok kolay) anlamına gelir.",
    "🍀 'Break a leg' aslında 'İyi şanslar' demek için kullanılır.",
    "🌧️ 'Raining cats and dogs' çok şiddetli yağmur yağdığını anlatır.",
    "🌙 'Once in a blue moon' deyimi 'Kırk yılda bir' (çok nadiren) anlamına gelir.",
    "✨ 'Serendipity', şans eseri güzel bir şey bulmak demektir.",
    "🤐 'Bite your tongue', bir şeyi söylememek için kendini tutmak demektir.",
    "🥶 'Cold feet', son anda korkup vazgeçmek anlamına gelir.",
    "🤥 'Cost an arm and a leg', bir şeyin çok pahalı olduğunu anlatır.",
    "🦋 'Butterflies in my stomach', heyecandan içi kıpır kıpır olmak demektir.",
    "🔥 'Burn the midnight oil', gece geç saatlere kadar çalışmak demektir.",
    "🐘 'Elephant in the room', herkesin bildiği ama konuşmadığı büyük sorun demektir.",
    "🕰️ 'Better late than never', geç olsun güç olmasın anlamına gelir.",
    "🚶‍♂️ 'Beat around the bush', lafı dolandırmak demektir.",
    "👀 'Eye to eye', biriyle tamamen aynı fikirde olmak demektir.",
    "🥔 'Couch potato', sürekli televizyon izleyen tembel kişi demektir.",
    "🧂 'Take it with a pinch of salt', her söylenene hemen inanmamak gerekir.",
    "🌤️ 'Under the weather', kendini biraz hasta veya keyifsiz hissetmek demektir.",
    "🛑 'Call it a day', bugünlük bu kadar yeter, paydos etmek anlamına gelir.",
    "📚 İngilizce sözlüğe her iki saatte bir yeni bir kelime eklenmektedir.",
    "✈️ İngilizce, dünya genelinde havacılık ve denizcilik resmi dilidir.",
    " Shakespeare, İngilizceye 1700'den fazla yeni kelime kazandırmıştır.",
    "🤷‍♂️ 'I am' İngilizcedeki en kısa tam cümledir.",
    "🎹 'Typewriter' (daktilo), klavyenin sadece en üst sırası kullanılarak yazılabilen en uzun kelimedir.",
    "🐝 'Bee's knees', bir şeyin mükemmel veya harika olduğunu anlatır.",
    "🧊 'Break the ice', bir ortamdaki gerginliği veya sessizliği bozmak demektir.",
    "👂 'Play it by ear', duruma göre hareket etmek, doğaçlama yapmak demektir.",
    "🐷 'When pigs fly', asla gerçekleşmeyecek bir şey için kullanılır (Çıkmaz ayın son çarşambası).",
    "🤝 'See eye to eye', biriyle aynı görüşte olmak demektir.",
    "🤐 'Zip your lip', çeneni kapat (sır tut) anlamına gelir.",
  ];

  final List<Map<String, String>> _categories = [
    {'id': 'Horror', 'name': 'Korku', 'icon': '👻'},
    {'id': 'Mystery', 'name': 'Dedektiflik', 'icon': '🕵️‍♂️'},
    {'id': 'Romance', 'name': 'Aşk', 'icon': '❤️'},
    {'id': 'Mixed', 'name': 'Karma', 'icon': '🎭'},
  ];

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  void _startLoadingTimer() {
    _currentFactIndex = 0;
    _loadingTimer?.cancel();
    _loadingTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _currentFactIndex = (_currentFactIndex + 1) % _loadingFacts.length;
      });
    });
  }

  Future<void> _generateStory() async {
    setState(() {
      _isLoading = true;
      _startLoadingTimer();
    });
    try {
      final storyData = await _geminiService.generateStory(
        level: _selectedLevel,
        category: _selectedCategory,
      );
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoryReaderScreen(
              storyData: storyData,
              walletService: widget.walletService,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hikaye oluşturulurken hata oluştu: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
      _loadingTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Hikaye Modu',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hikaye Seviyesi',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildLevelChip('B1'),
                      const SizedBox(width: 12),
                      _buildLevelChip('B2'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Hikaye Türü',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      return _buildCategoryCard(cat);
                    },
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _generateStory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: AppTheme.primary.withValues(alpha: 0.3),
                      ),
                      child: const Text(
                        'Hikayeyi Oluştur',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Gemini AI tarafından 700-800 kelimelik hikaye üretilir.',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                color: AppTheme.primary,
                strokeWidth: 4,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Hikayeniz Yazılıyor...',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Yaklaşık bekleme süresi: 45-60 saniye',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'İngilizce Biliyor Muydunuz?',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      _loadingFacts[_currentFactIndex],
                      key: ValueKey<int>(_currentFactIndex),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelChip(String level) {
    final isSelected = _selectedLevel == level;
    return GestureDetector(
      onTap: () => setState(() => _selectedLevel = level),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : AppTheme.primary.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Text(
          level,
          style: TextStyle(
            color: isSelected ? Colors.black : AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, String> cat) {
    final isSelected = _selectedCategory == cat['id'];
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = cat['id']!),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.1)
              : AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : Colors.white.withValues(alpha: 0.05),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(cat['icon']!, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              cat['name']!,
              style: TextStyle(
                color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
