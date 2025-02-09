import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/errors/failures.dart';
import 'package:fruits_hub/features/auth/domain/entites/user_entity.dart';

abstract class AuthRepo {
  /// Creates a new user account using the provided email and password.
  ///
  /// Returns an [Either] containing a [Failure] if an error occurs during
  /// the account creation process, or a [UserEntity] representing the newly
  /// created user if successful.

  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
      String email, String password);

  Future<Either<Failure, UserEntity>> signinWithEmailAndPassword(
      String email, String password);

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// تسجيل دخول فيس بوك محظور عندي

  // Future<Either<Failure, UserEntity>> signInWithFacebook();
  Future addUserData({required UserEntity user});

  Future<Either<Failure, UserEntity>> signInWithApple();
}
