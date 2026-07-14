part of 'property_review_detail_cubit.dart';

abstract class PropertyReviewDetailState extends Equatable {
  const PropertyReviewDetailState();

  @override
  List<Object?> get props => [];
}

class PropertyReviewInitial extends PropertyReviewDetailState {
  const PropertyReviewInitial();
}

class PropertyReviewLoading extends PropertyReviewDetailState {
  const PropertyReviewLoading();
}

class PropertyReviewLoaded extends PropertyReviewDetailState {
  final PropertyReviewDetail detail;
  final bool isSubmitting;

  const PropertyReviewLoaded(this.detail, {this.isSubmitting = false});

  PropertyReviewLoaded copyWith({bool? isSubmitting}) {
    return PropertyReviewLoaded(
      detail,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [detail, isSubmitting];
}

/// يُطلق بعد نجاح قبول/رفض العقار — الشاشة تستمع لهاد وتقفل نفسها وتظهر رسالة
class PropertyReviewActionSuccess extends PropertyReviewDetailState {
  final String message;
  const PropertyReviewActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PropertyReviewError extends PropertyReviewDetailState {
  final String message;
  const PropertyReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
