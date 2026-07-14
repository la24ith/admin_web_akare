import 'package:admin_web/features/property_moderation/domin/repository/property_moderation_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/property_moderation_entities.dart';

class GetPendingProperties
    implements UseCase<List<PropertyQueueItem>, NoParams> {
  final PropertyModerationRepository repository;
  GetPendingProperties(this.repository);

  @override
  Future<Either<Failure, List<PropertyQueueItem>>> call(NoParams params) {
    return repository.getPendingProperties();
  }
}
