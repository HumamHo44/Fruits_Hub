import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fruits_hub/core/errors/exceptions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService {
//  ----- createUserWithEmailAndPassword: Creates a new user account with the specified email and password. -----

// ================================ FUNCTION ====================================
// |  This function attempts to register a new user with Firebase Authentication |
// |  using the provided email and password. Upon successful registration,       |
// |  it returns the created [User] object.                                      |
// |                                                                             |
// |  Throws a [CustomException] if:                                             |
// |  - The password provided is too weak.                                       |
// |  - An account already exists for the specified email.                       |
// |  - Any other Firebase Authentication error occurs.                          |
// |                                                                             |
// |  Parameters:                                                                |
// |  [email]    : The email address for the new account.                        |
// |  [password] : The password for the new account.                             |
// ==============================================================================
  Future<User> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        " Exception in FirebaseAuthService.createUserWithEmailAndPassword: ${e.toString()} and code is ${e.code} ",
      );
      if (e.code == 'weak-password') {
        throw CustomException(message: 'الرقم السري ضعيف جدًا.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException(
            message: 'لقد قمت بالتسجل مسبقًا , يرجى تسجيل الدخول.');
      } else if (e.code == 'network-request-failed') {
        throw CustomException(message: 'تاكد من اتصالك بالانترنت');
      } else {
        throw CustomException(
            message: ' لقد حدث خطأ الآن, يرجى المحاولة مرة أخرى.');
      }
    } catch (e) {
      log(
        " Exception in FirebaseAuthService.createUserWithEmailAndPassword: ${e.toString()}",
      );
      throw CustomException(
          message: ' لقد حدث خطأ الآن, يرجى المحاولة مرة أخرى.');
    }
  }

  Future<User> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log("Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()} and code is ${e.code}");
      if (e.code == 'user-not-found') {
        throw CustomException(
            message: 'الرقم السري او البريد الالكتروني غير صحيح.');
      } else if (e.code == 'wrong-password') {
        throw CustomException(
            message: 'الرقم السري او البريد الالكتروني غير صحيح.');
      } else if (e.code == 'invalid-credential') {
        throw CustomException(
            message: 'الرقم السري او البريد الالكتروني غير صحيح.');
      } else if (e.code == 'network-request-failed') {
        throw CustomException(message: 'تاكد من اتصالك بالانترنت.');
      } else {
        throw CustomException(
            message: 'لقد حدث خطأ ما. الرجاء المحاولة مرة اخرى.');
      }
    } catch (e) {
      log("Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()}");

      throw CustomException(
          message: 'لقد حدث خطأ ما. الرجاء المحاولة مرة اخرى.');
    }
  }

  Future<User> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return (await FirebaseAuth.instance.signInWithCredential(credential)).user!;
  }

  /// تسجيل دخول فيس بوك محظور عندي

  // Future<User> signInWithFacebook() async {
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);
  //   final LoginResult loginResult =
  //       await FacebookAuth.instance.login(nonce: nonce);
  //   OAuthCredential facebookAuthCredential;

  //   if (Platform.isIOS) {
  //     switch (loginResult.accessToken!.type) {
  //       case AccessTokenType.classic:
  //         final token = loginResult.accessToken as ClassicToken;
  //         facebookAuthCredential = FacebookAuthProvider.credential(
  //           token.authenticationToken!,
  //         );
  //         break;
  //       case AccessTokenType.limited:
  //         final token = loginResult.accessToken as LimitedToken;
  //         facebookAuthCredential = OAuthCredential(
  //           providerId: 'facebook.com',
  //           signInMethod: 'oauth',
  //           idToken: token.tokenString,
  //           rawNonce: rawNonce,
  //         );
  //         break;
  //     }
  //   } else {
  //     facebookAuthCredential = FacebookAuthProvider.credential(
  //       loginResult.accessToken!.tokenString,
  //     );
  //   }

  //   return (await FirebaseAuth.instance
  //           .signInWithCredential(facebookAuthCredential))
  //       .user!;
  // }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    return (await FirebaseAuth.instance.signInWithCredential(oauthCredential))
        .user!;
  }
}
