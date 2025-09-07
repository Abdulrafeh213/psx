import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../firebase_options.dart';
import 'database_service.dart';

class FirebaseService implements DatabaseService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final profile = doc.exists ? doc.data() : null;

    // Merge profile fields with auth info (profile wins if present)
    return {
      if (profile != null) ...profile,
      'id': user.uid,
      'userId': user.uid,
      'email': user.email,
    };
  }

  @override
  Future<Map<String, dynamic>?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data();
  }

  @override
  Future<String?> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user?.uid;
    if (uid == null) return null;

    // Default profile image
    ByteData byteData = await rootBundle.load('assets/images/ProfileImage.png');
    String base64Image = base64Encode(byteData.buffer.asUint8List());

    await _firestore.collection('users').doc(uid).set({
      'userId': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'userRole': 'user',
      'userStatus': 'active',
      'profileImage': base64Image,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return uid;
  }

  @override
  Future<String?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user?.uid;
  }

  @override
  Future<String?> loginWithPhone({required String phone}) async {
    final snapshot = await _firestore
        .collection('users')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.id;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<void> saveUser(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).set(data);
  }

  @override
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }

  @override
  Future<void> saveUserLocation(
    String userId, {
    required double latitude,
    required double longitude,
    required String placeName,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'location': {
        'lat': latitude,
        'lng': longitude,
        'placeName': placeName,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    });
  }

  @override
  Future<Map<String, dynamic>?> getUserLocation(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['location'];
  }
}
