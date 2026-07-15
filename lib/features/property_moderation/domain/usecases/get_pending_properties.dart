import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/property_moderation_entities.dart';
import '../repositories/property_moderation_repository.dart';

class GetPendingProperties
    implements UseCase<List<PropertyQueueItem>, NoParams> {
  final PropertyModerationRepository repository;
  GetPendingProperties(this.repository);

  @override
  Future<Either<Failure, List<PropertyQueueItem>>> call(NoParams params) {
    return repository.getPendingProperties();
  }
}
