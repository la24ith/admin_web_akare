import 'package:admin_web/features/property_moderation/domin/entities/property_moderation_entities.dart';
import 'package:admin_web/features/property_moderation/domin/usecase/getPendingProperties.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';

part 'property_moderation_state.dart';

class PropertyModerationCubit extends Cubit<PropertyModerationState> {
  final GetPendingProperties getPendingProperties;

  PropertyModerationCubit({required this.getPendingProperties})
      : super(const PropertyModerationInitial());

  Future<void> loadPendingProperties() async {
    emit(const PropertyModerationLoading());

    final result = await getPendingProperties(const NoParams());

    result.fold(
      (failure) => emit(PropertyModerationError(failure.message)),
      (items) => emit(PropertyModerationLoaded(items)),
    );
  }

  Future<void> refresh() => loadPendingProperties();
}
