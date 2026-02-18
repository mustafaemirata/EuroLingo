import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'email': email,
      'username': username,
      'photoUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  
  Future<void> signOut() async {
    await _auth.signOut();
  }

  
  Future<Map<String, dynamic>?> getUserData() async {
    if (currentUser == null) return null;
    final doc = await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    return doc.data();
  }

  
  Stream<DocumentSnapshot> getUserStream() {
    if (currentUser == null) {
      return const Stream.empty();
    }
    return _firestore.collection('users').doc(currentUser!.uid).snapshots();
  }

  
  Future<String> uploadProfilePhoto(File imageFile) async {
    final uid = currentUser!.uid;
    final ref = _storage.ref().child('profile_photos/$uid.jpg');

    await ref.putFile(imageFile);
    final downloadUrl = await ref.getDownloadURL();

    
    await _firestore.collection('users').doc(uid).update({
      'photoUrl': downloadUrl,
    });

    return downloadUrl;
  }

  
  Future<void> updateUsername(String username) async {
    if (currentUser == null) return;
    await _firestore.collection('users').doc(currentUser!.uid).update({
      'username': username,
    });
  }

  
  Future<void> deleteAccount() async {
    final user = currentUser;
    if (user == null) return;

    final uid = user.uid;

    
    await _firestore.collection('users').doc(uid).delete();

    
    try {
      final ref = _storage.ref().child('profile_photos/$uid.jpg');
      await ref.delete();
    } catch (e) {
      
      debugPrint('Storage deletion error (probably doesn\'t exist): $e');
    }

    
    await user.delete();
  }
}
