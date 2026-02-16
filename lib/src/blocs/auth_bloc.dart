import 'dart:async';

import 'package:farmers_market/src/models/application_user.dart';
import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

class AuthBloc {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _user = BehaviorSubject<ApplicationUser?>.seeded(null);
  final _errorMessage = BehaviorSubject<String>.seeded('');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  //Get Data
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<bool> get isValid =>
      CombineLatestStream.combine2(email, password, (e, p) => true);
  Stream<ApplicationUser?> get user => _user.stream;
  Stream<String> get errorMessage => _errorMessage.stream;
  String? get userId => _user.valueOrNull?.userId;

  //Set Data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  void dispose() {
    _email.close();
    _password.close();
    _user.close();
    _errorMessage.close();
  }

  //Transformers
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (regExpEmail.hasMatch(email.trim())) {
      sink.add(email.trim());
    } else {
      sink.addError('Must Be Valid Email Address');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8) {
      sink.add(password.trim());
    } else {
      sink.addError('8 Character Minimum');
    }
  });

  //Functions
  Future<void> signupEmail() async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());
      final uid = authResult.user?.uid;
      if (uid == null) {
        _errorMessage.sink.add('User ID tidak ditemukan');
        return;
      }

      final user = ApplicationUser(userId: uid, email: _email.value.trim());
      await _firestoreService.addUser(user);
      _user.sink.add(user);
    } on FirebaseAuthException catch (error) {
      _errorMessage.sink.add(error.message ?? 'Terjadi kesalahan autentikasi');
    }
  }

  Future<void> loginEmail() async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());
      final uid = authResult.user?.uid;
      if (uid == null) {
        _errorMessage.sink.add('User ID tidak ditemukan');
        return;
      }

      final appUser = await _firestoreService.fetchUser(uid);
      _user.sink.add(appUser);
    } on FirebaseAuthException catch (error) {
      _errorMessage.sink.add(error.message ?? 'Terjadi kesalahan autentikasi');
    }
  }

  Future<bool> isLoggedIn() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return false;

    final appUser = await _firestoreService.fetchUser(firebaseUser.uid);
    if (appUser == null) return false;

    _user.sink.add(appUser);
    return true;
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user.sink.add(null);
  }

  void clearErrorMessage() {
    _errorMessage.sink.add('');
  }
}
