import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruits_hub/core/errors/exceptions.dart';

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
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        " Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()} and code is ${e.code} ",
      );
      if (e.code == 'user-not-found') {
        throw CustomException(
            message: 'البريد الالكتروني او الرقم السري غير صحيح');
      } else if (e.code == 'wrong-password') {
        throw CustomException(
            message: 'البريد الالكتروني او الرقم السري غير صحيح');
      } else if (e.code == 'network-request-failed') {
        throw CustomException(message: 'تاكد من اتصالك بالانترنت');
      } else {
        throw CustomException(
            message: ' لقد حدث خطأ الآن, يرجى المحاولة مرة أخرى.');
      }
    } catch (e) {
      log(
        " Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()}",
      );
      throw CustomException(
          message: ' لقد حدث خطأ الآن, يرجى المحاولة مرة أخرى.');
    }
  }
}
