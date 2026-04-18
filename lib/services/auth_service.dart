import 'dart:io';

import 'package:flutter/foundation.dart';
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
    } on GoogleSignInException catch (e, st) {
      debugPrint('[AuthService] GoogleSignInException: $e');
      debugPrint('[AuthService] Stack: $st');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw Exception('Sign-in was cancelled');
      }
      rethrow;
    } catch (e, st) {
      debugPrint('[AuthService] signInWithGoogle error: $e');
      debugPrint('[AuthService] Stack: $st');
      rethrow;
    }

    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      debugPrint('[AuthService] idToken is null');
      throw Exception('Failed to get ID token from Google');
    }

    try {
      return await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
    } catch (e, st) {
      debugPrint('[AuthService] Supabase signInWithIdToken error: $e');
      debugPrint('[AuthService] Stack: $st');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      await _ensureGoogleInitialized();
      await GoogleSignIn.instance.signOut();
    } catch (e, st) {
      debugPrint('[AuthService] Google signOut error: $e');
      debugPrint('[AuthService] Stack: $st');
    }
    try {
      await _supabase.auth.signOut();
    } catch (e, st) {
      debugPrint('[AuthService] Supabase signOut error: $e');
      debugPrint('[AuthService] Stack: $st');
      rethrow;
    }
  }

  static Session? get currentSession => _supabase.auth.currentSession;

  static User? get currentUser => _supabase.auth.currentUser;

  static bool get isLoggedIn => currentSession != null;

  static Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  static Future<UserResponse> updateUserMetadata(Map<String, dynamic> data) async {
    try {
      return await _supabase.auth.updateUser(UserAttributes(data: data));
    } catch (e, st) {
      debugPrint('[AuthService] updateUserMetadata error: $e');
      debugPrint('[AuthService] Stack: $st');
      rethrow;
    }
  }

  static Future<UserResponse> updatePhone(String phone) async {
    try {
      return await _supabase.auth.updateUser(
        UserAttributes(data: {'phone': phone}),
      );
    } catch (e, st) {
      debugPrint('[AuthService] updatePhone error: $e');
      debugPrint('[AuthService] Stack: $st');
      rethrow;
    }
  }
}
