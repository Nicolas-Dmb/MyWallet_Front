import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart' show Failure;

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
