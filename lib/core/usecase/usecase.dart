import 'package:bloc_app_clean_solidp_bloc/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecase<SuccessType, Params>{
  Future<Either<Failure,SuccessType>> call(Params params);
}