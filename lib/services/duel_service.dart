import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eurolingo/data/word_data.dart';
import 'package:eurolingo/data/word_data_b2.dart';
import 'package:eurolingo/models/word_model.dart';

class DuelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Random _random = Random();

  
  String _generateRoomCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(6, (_) => chars[_random.nextInt(chars.length)]).join();
  }

  
  List<Map<String, dynamic>> _generateQuestions({
    String level = 'Mixed',
    List<String>? letters,
  }) {
    List<WordItem> pool;
    if (level == 'B1') {
      pool = [...allWords];
    } else if (level == 'B2') {
      pool = [...allWordsB2];
    } else {
      pool = [...allWords, ...allWordsB2];
    }

    
    if (letters != null && letters.isNotEmpty) {
      final uppercaseLetters = letters.map((l) => l.toUpperCase()).toList();
      pool = pool.where((w) {
        final firstChar = w.term[0].toUpperCase();
        return uppercaseLetters.contains(firstChar);
      }).toList();
    }

    
    int countToTake;
    if (level == 'Mixed' && (letters == null || letters.isEmpty)) {
      countToTake = 50;
    } else {
      
      countToTake = min(pool.length, 50);
    }

    pool.shuffle(_random);
    final selected = pool.take(countToTake).toList();
    final questions = <Map<String, dynamic>>[];

    for (final word in selected) {
      final correctAnswer = word.primaryMeaning;

      
      final allPossible = [...allWords, ...allWordsB2];
      final others =
          allPossible
              .where(
                (w) => w.term != word.term && w.primaryMeaning != correctAnswer,
              )
              .toList()
            ..shuffle(_random);

      final wrongAnswers = <String>[];
      for (final w in others) {
        if (wrongAnswers.length >= 3) break;
        final m = w.primaryMeaning;
        if (!wrongAnswers.contains(m) && m != correctAnswer) {
          wrongAnswers.add(m);
        }
      }

      final options = [...wrongAnswers, correctAnswer]..shuffle(_random);

      questions.add({
        'term': word.term,
        'correctAnswer': correctAnswer,
        'options': options,
      });
    }

    return questions;
  }

  
  Future<String> createRoom({
    required String uid,
    required String username,
    String? photoUrl,
    String level = 'Mixed',
    List<String>? letters,
  }) async {
    String roomCode = _generateRoomCode();

    
    while ((await _firestore.collection('duels').doc(roomCode).get()).exists) {
      roomCode = _generateRoomCode();
    }

    final questions = _generateQuestions(level: level, letters: letters);

    await _firestore.collection('duels').doc(roomCode).set({
      'hostUid': uid,
      'hostUsername': username,
      'hostPhotoUrl': photoUrl ?? '',
      'guestUid': '',
      'guestUsername': '',
      'guestPhotoUrl': '',
      'status': 'waiting',
      'level': level,
      'letters': letters ?? [],
      'questions': questions,
      'hostAnswers': [],
      'guestAnswers': [],
      'hostScore': 0,
      'guestScore': 0,
      'hostFinished': false,
      'guestFinished': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return roomCode;
  }

  
  Future<Map<String, dynamic>?> joinRoom({
    required String roomCode,
    required String uid,
    required String username,
    String? photoUrl,
  }) async {
    final docRef = _firestore.collection('duels').doc(roomCode);
    final doc = await docRef.get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    if (data['status'] != 'waiting') return null;
    if (data['hostUid'] == uid) return null; 

    await docRef.update({
      'guestUid': uid,
      'guestUsername': username,
      'guestPhotoUrl': photoUrl ?? '',
      'status': 'playing',
    });

    return (await docRef.get()).data();
  }

  
  Future<void> submitAnswer({
    required String roomCode,
    required String uid,
    required int questionIndex,
    required String answer,
    required bool isCorrect,
  }) async {
    final docRef = _firestore.collection('duels').doc(roomCode);
    final doc = await docRef.get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final isHost = data['hostUid'] == uid;

    final answerData = {
      'questionIndex': questionIndex,
      'answer': answer,
      'isCorrect': isCorrect,
      'answeredAt': DateTime.now().toIso8601String(),
    };

    try {
      if (isHost) {
        await docRef.update({
          'hostAnswers': FieldValue.arrayUnion([answerData]),
          if (isCorrect) 'hostScore': FieldValue.increment(1),
        });
      } else {
        await docRef.update({
          'guestAnswers': FieldValue.arrayUnion([answerData]),
          if (isCorrect) 'guestScore': FieldValue.increment(1),
        });
      }
    } catch (e) {
      print('Error submitting answer: $e');
    }
  }

  
  Future<void> markFinished(String roomCode, String uid) async {
    final docRef = _firestore.collection('duels').doc(roomCode);
    final doc = await docRef.get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final isHost = data['hostUid'] == uid;

    if (isHost) {
      await docRef.update({
        'hostFinished': true,
        'hostFinishedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await docRef.update({
        'guestFinished': true,
        'guestFinishedAt': FieldValue.serverTimestamp(),
      });
    }

    
    final updated = (await docRef.get()).data()!;
    if (updated['hostFinished'] == true && updated['guestFinished'] == true) {
      await docRef.update({'status': 'finished'});
    }
  }

  
  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToRoom(String roomCode) {
    return _firestore.collection('duels').doc(roomCode).snapshots();
  }

  
  Future<void> deleteRoom(String roomCode) async {
    await _firestore.collection('duels').doc(roomCode).delete();
  }
}
