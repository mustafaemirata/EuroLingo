import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MistakeEntry {
  final String term;
  final String correctMeaning;
  final String userAnswer;
  final DateTime timestamp;
  final bool isActive;

  MistakeEntry({
    required this.term,
    required this.correctMeaning,
    required this.userAnswer,
    DateTime? timestamp,
    this.isActive = true,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'term': term,
    'correctMeaning': correctMeaning,
    'userAnswer': userAnswer,
    'timestamp': Timestamp.fromDate(timestamp),
    'isActive': isActive,
  };

  factory MistakeEntry.fromFirestore(Map<String, dynamic> json) {
    DateTime ts = DateTime.now();
    if (json['timestamp'] is Timestamp) {
      ts = (json['timestamp'] as Timestamp).toDate();
    } else if (json['timestamp'] is String) {
      ts = DateTime.tryParse(json['timestamp']) ?? DateTime.now();
    }

    return MistakeEntry(
      term: json['term'] ?? '',
      correctMeaning: json['correctMeaning'] ?? '',
      userAnswer: json['userAnswer'] ?? '',
      timestamp: ts,
      isActive: json['isActive'] ?? true,
    );
  }
}

class MistakeService extends ChangeNotifier {
  final List<MistakeEntry> _mistakes = [];
  StreamSubscription? _subscription;
  String? _userId;

  MistakeService() {
    _init();
  }

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _userId = user?.uid;
      _subscription?.cancel();

      if (_userId != null) {
        _subscribeToMistakes();
      } else {
        _mistakes.clear();
        notifyListeners();
      }
    });
  }

  void _subscribeToMistakes() {
    if (_userId == null) return;

    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('mistakes')
        .where('isActive', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
          _mistakes.clear();
          for (var doc in snapshot.docs) {
            _mistakes.add(MistakeEntry.fromFirestore(doc.data()));
          }
          notifyListeners();
        });
  }

  
  List<MistakeEntry> get uniqueMistakes => List.unmodifiable(_mistakes);
  List<MistakeEntry> get mistakes => List.unmodifiable(_mistakes);
  int get count => _mistakes.length;

  Future<void> addMistake(MistakeEntry entry) async {
    if (_userId == null) return;

    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('mistakes');

    
    final query = await collection
        .where('term', isEqualTo: entry.term)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      
      final docId = query.docs.first.id;
      await collection.doc(docId).update({
        'isActive': true,
        'timestamp': FieldValue.serverTimestamp(),
        'userAnswer': entry.userAnswer,
        'correctMeaning': entry.correctMeaning,
      });
    } else {
      
      await collection.add(entry.toJson());
    }
  }

  Future<void> removeMistake(String term) async {
    if (_userId == null) return;

    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('mistakes');

    final query = await collection
        .where('term', isEqualTo: term)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      
      await collection.doc(query.docs.first.id).update({'isActive': false});
    }
  }

  Future<void> clearAll() async {
    if (_userId == null) return;

    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('mistakes');

    
    final snapshot = await collection.where('isActive', isEqualTo: true).get();

    if (snapshot.docs.isEmpty) return;

    final batch = FirebaseFirestore.instance.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isActive': false});
    }

    await batch.commit();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
