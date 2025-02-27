import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruits_hub/core/errors/exceptions.dart';
import 'package:fruits_hub/core/errors/failures.dart';
import 'package:fruits_hub/core/services/data_base_services.dart';
import 'package:fruits_hub/core/services/firebase_auth_service.dart';
import 'package:fruits_hub/core/utils/backend_endpoint.dart';
import 'package:fruits_hub/features/auth/data/model/user_model.dart';
import 'package:fruits_hub/features/auth/domain/entites/user_entity.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService databaseService;

  AuthRepoImpl({
    required this.databaseService,
    required this.firebaseAuthService,
  });
  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    User? user;
    try {
      user = await firebaseAuthService.createUserWithEmailAndPassword(
          email: email, password: password);
      var userEntity = UserEntity(
        name: name,
        email: email,
        uId: user.uid,
      );
      await addUserData(user: userEntity);

      return right(userEntity);
    } on CustomException catch (e) {
      await deletUser(user);
      return left(ServerFailure(e.message));
    } catch (e) {
      await deletUser(user);
      log(
        'Exception in AuthRepoImpl.createUserWithEmailAndPassword: ${e.toString()}',
      );
      return left(
        const ServerFailure(
          'لقد حدث خطأ الآن, يرجى المحاولة مرة أخرى.',
        ),
      );
    }
  }

  Future<void> deletUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signinWithEmailAndPassword(
      String email, String password) async {
    try {
      var user = await firebaseAuthService.signInWithEmailAndPassword(
          email: email, password: password);
      var userEntity = await getUserData(uid: user.uid);
      return right(userEntity);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.signInWithEmailAndPassword: ${e.toString()}',
      );
      return left(
        const ServerFailure(
          'لقد حدث خطأ الآن, يرجى المحاولة مرة أخرى.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    User? user;
    try {
      var user = await firebaseAuthService.signInWithGoogle();
      var userEntuty = UserModel.fromFirebaseUser(user);
      var isUserExist = await databaseService.checkIfDataExists(
          path: BackendEndpoint.addUserData, documentId: user.uid);
      if (isUserExist) {
        await getUserData(uid: user.uid);
      } else {
        await addUserData(user: userEntuty);
      }
      return right(userEntuty);
    } catch (e) {
      await deletUser(user);
      log(
        'Exception in AuthRepoImpl.signInWithGoogle: ${e.toString()}',
      );
      return left(
        const ServerFailure(
          'لقد حدث خطأ الآن, يرجى المحاولة مرة أخرى.',
        ),
      );
    }
  }

  /// تسجيل دخول فيس بوك محظور عندي

  @override
  // Future<Either<Failure, UserEntity>> signInWithFacebook() async {
  //   User? user;
  //   try {
  //     var user = await firebaseAuthService.signInWithFacebook();
  //     var userEntuty = UserModel.fromFirebaseUser(user);
  //     var isUserExist = await databaseService.checkIfDataExists(
  //         path: BackendEndpoint.addUserData, documentId: user.uid);
  //     if (isUserExist) {
  //       await getUserData(uid: user.uid);
  //     } else {
  //       await addUserData(user: userEntuty);
  //     }
  //     return right(userEntuty);
  //   } catch (e) {
  //     await deletUser(user);
  //     log(
  //       'Exception in AuthRepoImpl.signInWithFacebook: ${e.toString()}',
  //     );
  //     return left(
  //       const ServerFailure(
  //         'لقد حدث خطأ الآن, يرجى المحاولة مرة أخرى.',
  //       ),
  //     );
  //   }
  // }

  @override
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    User? user;
    try {
      var user = await firebaseAuthService.signInWithApple();
      var userEntuty = UserModel.fromFirebaseUser(user);
      var isUserExist = await databaseService.checkIfDataExists(
          path: BackendEndpoint.addUserData, documentId: user.uid);
      if (isUserExist) {
        await getUserData(uid: user.uid);
      } else {
        await addUserData(user: userEntuty);
      }
      return right(userEntuty);
    } catch (e) {
      await deletUser(user);
      log(
        'Exception in AuthRepoImpl.signInWithApple: ${e.toString()}',
      );
      return left(
        const ServerFailure(
          'لقد حدث خطأ الآن, يرجى المحاولة مرة أخرى.',
        ),
      );
    }
  }

  @override
  Future addUserData({required UserEntity user}) async {
    await databaseService.addData(
        path: BackendEndpoint.addUserData,
        data: user.toMap(),
        documentId: user.uId);
  }

  @override
  Future<UserEntity> getUserData({required String uid}) async {
    var userData = await databaseService.getData(
        path: BackendEndpoint.addUserData, documentId: uid);
    return UserModel.fromJson(userData);
  }
}
