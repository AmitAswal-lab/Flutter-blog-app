import 'package:bloc_app_clean_solidp_bloc/core/error/failure.dart';
import 'package:bloc_app_clean_solidp_bloc/core/usecase/usecase.dart';
import 'package:bloc_app_clean_solidp_bloc/core/common/enitites/user.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams parmas) async {
    return await authRepository.currentUser();
  }
}
