import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletService extends ChangeNotifier {
  static const String _key = 'saved_words';
  static const String _customDefsKey = 'custom_definitions';
  final Set<String> _savedTerms = {};
  final Map<String, List<String>> _customDefinitions = {};

  List<Map<String, dynamic>> _irregularVerbs = [];
  List<Map<String, dynamic>> _regularVerbs = [];
  bool _verbsLoaded = false;

  WalletService() {
    _load();
    _loadVerbs();
  }

  Set<String> get savedTerms => Set.unmodifiable(_savedTerms);
  Map<String, List<String>> get customDefinitions =>
      Map.unmodifiable(_customDefinitions);

  
  int get count => _savedTerms.length;

  
  int get savedWordsCount {
    if (!_verbsLoaded) return count; 

    int wordCount = 0;
    for (final term in _savedTerms) {
      if (!isVerb(term)) {
        wordCount++;
      }
    }
    return wordCount;
  }

  bool isSaved(String term) => _savedTerms.contains(term.toLowerCase());

  bool isVerb(String term) {
    if (!_verbsLoaded) return false;
    final lowerTerm = term.toLowerCase();

    
    try {
      _irregularVerbs.firstWhere(
        (v) => (v['V1'] ?? '').toString().toLowerCase() == lowerTerm,
      );
      return true;
    } catch (_) {}

    
    try {
      _regularVerbs.firstWhere(
        (v) => (v['V1'] ?? '').toString().toLowerCase() == lowerTerm,
      );
      return true;
    } catch (_) {}

    return false;
  }

  Future<void> toggle(String term, {List<String>? meanings}) async {
    final key = term.toLowerCase();
    if (_savedTerms.contains(key)) {
      _savedTerms.remove(key);
      _customDefinitions.remove(key);
    } else {
      _savedTerms.add(key);
      if (meanings != null && meanings.isNotEmpty) {
        _customDefinitions[key] = meanings;
      }
    }
    notifyListeners();
    await _save();
  }

  Future<void> remove(String term) async {
    final key = term.toLowerCase();
    _savedTerms.remove(key);
    _customDefinitions.remove(key);
    notifyListeners();
    await _save();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key);
    if (data != null) {
      _savedTerms.addAll(data);
    }

    final customData = prefs.getString(_customDefsKey);
    if (customData != null) {
      try {
        final decoded = json.decode(customData) as Map<String, dynamic>;
        decoded.forEach((key, value) {
          if (value is List) {
            _customDefinitions[key] = List<String>.from(value);
          }
        });
      } catch (e) {
        debugPrint('Error loading custom definitions: $e');
      }
    }
    notifyListeners();
  }

  Future<void> _loadVerbs() async {
    try {
      final irregularJson = await rootBundle.loadString(
        'assets/irregular.json',
      );
      final regularJson = await rootBundle.loadString('assets/regular.json');

      _irregularVerbs = List<Map<String, dynamic>>.from(
        json.decode(irregularJson),
      );
      _regularVerbs = List<Map<String, dynamic>>.from(json.decode(regularJson));
      _verbsLoaded = true;
      notifyListeners(); 
    } catch (e) {
      debugPrint('Error loading verbs in service: $e');
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _savedTerms.toList());

    if (_customDefinitions.isNotEmpty) {
      await prefs.setString(_customDefsKey, json.encode(_customDefinitions));
    }
  }
}
