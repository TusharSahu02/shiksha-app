import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();

  static final _supabase = Supabase.instance.client;

  static const _webClientId = '593488643377-e61rdvem78s1040lsasvno263bkt2d7c.apps.googleusercontent.com';
  // TODO: Add iOS Client ID when targeting iOS
  static const _iosClientId = '';

  static bool _googleInitialized = false;

  static Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    await GoogleSignIn.instance.initialize(
      clientId: Platform.isIOS ? _iosClientId : null,
      serverClientId: _webClientId,
    );
    _googleInitialized = true;
  }

  static Future<AuthResponse> signInWithGoogle() async {
    await _ensureGoogleInitialized();

    final GoogleSignInAccount googleUser;
    try {
      googleUser = await GoogleSignIn.instance.authenticate(
        scopeHint: ['email'],
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw Exception('Sign-in was cancelled');
      }
      rethrow;
    }

    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw Exception('Failed to get ID token from Google');
    }

    return _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
  }

  static Future<void> signOut() async {
    try {
      await _ensureGoogleInitialized();
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    await _supabase.auth.signOut();
  }

  static Session? get currentSession => _supabase.auth.currentSession;

  static User? get currentUser => _supabase.auth.currentUser;

  static bool get isLoggedIn => currentSession != null;

  static Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
