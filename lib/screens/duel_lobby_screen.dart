import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eurolingo/theme/app_theme.dart';
import 'package:eurolingo/services/duel_service.dart';
import 'package:eurolingo/services/auth_service.dart';
import 'package:eurolingo/screens/duel_game_screen.dart';

class DuelLobbyScreen extends StatefulWidget {
  const DuelLobbyScreen({super.key});

  @override
  State<DuelLobbyScreen> createState() => _DuelLobbyScreenState();
}

class _DuelLobbyScreenState extends State<DuelLobbyScreen>
    with TickerProviderStateMixin {
  final DuelService _duelService = DuelService();
  final AuthService _authService = AuthService();
  final _codeController = TextEditingController();

  String? _roomCode;
  bool _isCreating = false;
  bool _isJoining = false;
  bool _isWaiting = false;
  String _username = '';
  String? _photoUrl;
  StreamSubscription? _roomSubscription;
  late AnimationController _pulseController;

  
  String _selectedLevel = 'Mixed';
  final List<String> _selectedLetters = [];
  final List<String> _allLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _roomSubscription?.cancel();
    _codeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final data = await _authService.getUserData();
    if (mounted && data != null) {
      setState(() {
        _username = data['username'] ?? 'Oyuncu';
        _photoUrl = data['photoUrl'];
      });
    }
  }

  Future<void> _createRoom() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isCreating = true);

    try {
      final code = await _duelService.createRoom(
        uid: uid,
        username: _username,
        photoUrl: _photoUrl,
        level: _selectedLevel,
        letters: _selectedLetters,
      );
      setState(() {
        _roomCode = code;
        _isCreating = false;
        _isWaiting = true;
      });

      
      _roomSubscription = _duelService.listenToRoom(code).listen((snapshot) {
        final data = snapshot.data();
        if (data != null && data['status'] == 'playing' && mounted) {
          _roomSubscription?.cancel();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => DuelGameScreen(roomCode: code, isHost: true),
            ),
          );
        }
      });
    } catch (e) {
      setState(() => _isCreating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Oda oluşturulamadı: $e'),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _joinRoom() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lütfen 6 haneli oda kodunu girin.'),
          backgroundColor: AppTheme.errorRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isJoining = true);

    try {
      final result = await _duelService.joinRoom(
        roomCode: code,
        uid: uid,
        username: _username,
        photoUrl: _photoUrl,
      );
      if (result == null) {
        if (mounted) {
          setState(() => _isJoining = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Oda bulunamadı veya dolu.'),
              backgroundColor: AppTheme.errorRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
        return;
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => DuelGameScreen(roomCode: code, isHost: false),
          ),
        );
      }
    } catch (e) {
      setState(() => _isJoining = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Katılınamadı: $e'),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _cancelWaiting() async {
    _roomSubscription?.cancel();
    if (_roomCode != null) {
      await _duelService.deleteRoom(_roomCode!);
    }
    if (mounted) {
      setState(() {
        _isWaiting = false;
        _roomCode = null;
      });
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
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: AppTheme.textPrimary,
          onPressed: () {
            if (_isWaiting) {
              _cancelWaiting();
            }
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Online Düello',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isWaiting ? _buildWaitingScreen() : _buildLobbyScreen(),
      ),
    );
  }

  int _tabIndex = 0; 

  Widget _buildLobbyScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          
          _buildUserProfileHeader(),

          const SizedBox(height: 24),

          
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildToggleOption(
                  index: 0,
                  title: 'Oda Oluştur',
                  icon: Icons.add_circle_outline_rounded,
                ),
                _buildToggleOption(
                  index: 1,
                  title: 'Odaya Katıl',
                  icon: Icons.login_rounded,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _tabIndex == 0 ? _buildCreateTab() : _buildJoinTab(),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.black : AppTheme.textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.black : AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateTab() {
    return Column(
      key: const ValueKey('create'),
      children: [
        
        _buildSettingsCard(),

        const SizedBox(height: 24),

        
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton.icon(
            onPressed: _isCreating ? null : _createRoom,
            icon: _isCreating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF121214),
                    ),
                  )
                : const Icon(Icons.play_arrow_rounded, size: 28),
            label: Text(
              _isCreating ? 'Oluşturuluyor...' : 'Oda Oluştur',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.black,
              disabledBackgroundColor: AppTheme.primary.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJoinTab() {
    return Container(
      key: const ValueKey('join'),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Icon(
              Icons.keyboard_alt_rounded,
              size: 48,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Oda Kodunu Gir',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Arkadaşının paylaştığı 6 haneli kodu buraya yaz.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textMuted,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),

          TextFormField(
            controller: _codeController,
            textCapitalization: TextCapitalization.characters,
            maxLength: 6,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: 10,
            ),
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              UpperCaseTextFormatter(),
            ],
            decoration: InputDecoration(
              counterText: '',
              hintText: 'CODE',
              hintStyle: TextStyle(
                color: AppTheme.textMuted.withValues(alpha: 0.2),
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: 10,
              ),
              filled: true,
              fillColor: AppTheme.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppTheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isJoining ? null : _joinRoom,
              icon: _isJoining
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Icon(Icons.login_rounded, size: 22),
              label: Text(
                _isJoining ? 'Katılınıyor...' : 'Odaya Katıl',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.black,
                disabledBackgroundColor: AppTheme.primary.withValues(
                  alpha: 0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppTheme.surfaceCard,
          backgroundImage: _photoUrl != null && _photoUrl!.isNotEmpty
              ? NetworkImage(_photoUrl!)
              : null,
          child: _photoUrl == null || _photoUrl!.isEmpty
              ? const Icon(Icons.person_rounded, color: AppTheme.primary)
              : null,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _username,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const Text(
              'Çevrimiçi',
              style: TextStyle(fontSize: 12, color: AppTheme.accentGreen),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.settings_rounded, color: AppTheme.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Oda Ayarları',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          
          const Text(
            'Kelime Seviyesi',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildLevelOption('B1'),
              const SizedBox(width: 8),
              _buildLevelOption('B2'),
              const SizedBox(width: 8),
              _buildLevelOption('Mixed', label: 'Karma'),
            ],
          ),

          const SizedBox(height: 24),

          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Harf Seçimi (Opsiyonel)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
              if (_selectedLetters.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() => _selectedLetters.clear()),
                  child: const Text(
                    'Temizle',
                    style: TextStyle(fontSize: 12, color: AppTheme.primary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _allLetters
                .take(13)
                .map((l) => _buildLetterChip(l))
                .toList(),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _allLetters
                .skip(13)
                .map((l) => _buildLetterChip(l))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelOption(String level, {String? label}) {
    final isSelected = _selectedLevel == level;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedLevel = level),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : AppTheme.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primary
                  : AppTheme.textMuted.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Text(
            label ?? level,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.black : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterChip(String letter) {
    final isSelected = _selectedLetters.contains(letter);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedLetters.remove(letter);
          } else {
            if (_selectedLetters.length < 5) {
              _selectedLetters.add(letter);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('En fazla 5 harf seçebilirsiniz.'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          }
        });
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : AppTheme.textMuted.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.black : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWaitingScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.08),
                  child: child,
                );
              },
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Rakip Bekleniyor...',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Oda kodunu arkadaşınla paylaş',
              style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 28),

            
            GestureDetector(
              onTap: () {
                if (_roomCode != null) {
                  Clipboard.setData(ClipboardData(text: _roomCode!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Oda kodu kopyalandı!'),
                      backgroundColor: AppTheme.accentGreen,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _roomCode ?? '',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primary,
                        letterSpacing: 6,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.copy_rounded,
                      color: AppTheme.textMuted.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),

            
            TextButton(
              onPressed: () {
                _cancelWaiting();
              },
              child: const Text(
                'İptal Et',
                style: TextStyle(
                  color: AppTheme.errorRed,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
