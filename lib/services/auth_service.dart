
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<AppUser> register({
    required String displayName,
    required String email,
    required String password,
    String? gender,
    Map<String, dynamic>? otherDetails,
    required bool agreedToTerms,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await cred.user!.updateDisplayName(displayName);
    final uid = cred.user!.uid;

    final userDoc = AppUser(
      uid: uid,
      displayName: displayName,
      email: email,
      gender: gender,
      otherDetails: otherDetails,
      agreedToTerms: agreedToTerms,
    );
    await _db.collection('users').doc(uid).set(userDoc.toMap(), SetOptions(merge: true));
    return userDoc;
  }

  Future<AppUser> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final uid = cred.user!.uid;
    final snap = await _db.collection('users').doc(uid).get();
    if (snap.exists) {
      return AppUser.fromMap(uid, snap.data()!);
    } else {
      // Fallback if user exists in auth but not in DB
      final appUser = AppUser(uid: uid, displayName: cred.user!.displayName ?? '', email: cred.user!.email ?? '');
      await _db.collection('users').doc(uid).set(appUser.toMap(), SetOptions(merge: true));
      return appUser;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<AppUser?> currentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final snap = await _db.collection('users').doc(user.uid).get();
    if (snap.exists) return AppUser.fromMap(user.uid, snap.data()!);
    return null;
  }

  Future<void> updateProfile(AppUser user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap(), SetOptions(merge: true));
    await _auth.currentUser?.updateDisplayName(user.displayName);
  }
}
