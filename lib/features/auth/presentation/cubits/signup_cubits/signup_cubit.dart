import 'package:bloc/bloc.dart';
import 'package:fruits_hub/features/auth/domain/entites/user_entity.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this.authRepo) : super(SignUpInitial());

  final AuthRepo authRepo;

  Future<void> signUp(
    String email,
    String password,
  ) async {
    emit(SignUpLoading());
    var result = await authRepo.createUserWithEmailAndPassword(email, password);
    result.fold(
      (failure) => emit(
        SignUpFailure(message: failure.message),
      ),
      (userEntity) => emit(
        SignUpSuccess(userEntity: userEntity),
      ),
    );
  }
}
