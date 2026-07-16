import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/property_list_row.dart';
import '../repositories/all_properties_repository.dart';

class GetAllProperties
    implements UseCase<List<PropertyListRow>, GetAllPropertiesParams> {
  final AllPropertiesRepository repository;
  GetAllProperties(this.repository);

  @override
  Future<Either<Failure, List<PropertyListRow>>> call(
      GetAllPropertiesParams params) {
    return repository.getAllProperties(
      status: params.status,
      searchQuery: params.searchQuery,
    );
  }
}

class GetAllPropertiesParams extends Equatable {
  final String? status;
  final String? searchQuery;
  const GetAllPropertiesParams({this.status, this.searchQuery});

  @override
  List<Object?> get props => [status, searchQuery];
}
