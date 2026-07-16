import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/all_properties_repository.dart';

class DisableProperty implements UseCase<void, DisablePropertyParams> {
  final AllPropertiesRepository repository;
  DisableProperty(this.repository);

  @override
  Future<Either<Failure, void>> call(DisablePropertyParams params) {
    return repository.disableProperty(params.propertyId);
  }
}

class DisablePropertyParams extends Equatable {
  final String propertyId;
  const DisablePropertyParams(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}
