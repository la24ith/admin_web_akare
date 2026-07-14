import 'package:admin_web/features/property_moderation/domin/entities/property_moderation_entities.dart';
import 'package:admin_web/features/property_moderation/domin/usecase/approve_property.dart';
import 'package:admin_web/features/property_moderation/domin/usecase/get_property_review_detail.dart';
import 'package:admin_web/features/property_moderation/domin/usecase/reject_property.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'property_review_detail_state.dart';

class PropertyReviewDetailCubit extends Cubit<PropertyReviewDetailState> {
  final GetPropertyReviewDetail getPropertyReviewDetail;

  final ApproveProperty approveProperty;
  final RejectProperty rejectProperty;

  PropertyReviewDetailCubit({
    required this.getPropertyReviewDetail,
    required this.approveProperty,
    required this.rejectProperty,
  }) : super(const PropertyReviewInitial());

  Future<void> loadDetail(String propertyId) async {
    emit(const PropertyReviewLoading());

    final result = await getPropertyReviewDetail(
        GetPropertyReviewDetailParams(propertyId));

    result.fold(
      (failure) => emit(PropertyReviewError(failure.message)),
      (detail) => emit(PropertyReviewLoaded(detail)),
    );
  }

  Future<void> approve() async {
    final current = state;
    if (current is! PropertyReviewLoaded) return;

    emit(current.copyWith(isSubmitting: true));

    final result = await approveProperty(
      ApprovePropertyParams(current.detail.id),
    );

    result.fold(
      (failure) {
        emit(PropertyReviewError(failure.message));
        emit(current.copyWith(isSubmitting: false));
      },
      (_) => emit(const PropertyReviewActionSuccess('تم قبول العقار بنجاح')),
    );
  }

  Future<void> reject(String reason) async {
    final current = state;
    if (current is! PropertyReviewLoaded) return;

    emit(current.copyWith(isSubmitting: true));

    final result = await rejectProperty(
      RejectPropertyParams(propertyId: current.detail.id, reason: reason),
    );

    result.fold(
      (failure) {
        emit(PropertyReviewError(failure.message));
        emit(current.copyWith(isSubmitting: false));
      },
      (_) => emit(const PropertyReviewActionSuccess('تم رفض العقار')),
    );
  }
}
