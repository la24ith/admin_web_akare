part of 'property_moderation_cubit.dart';

abstract class PropertyModerationState extends Equatable {
  const PropertyModerationState();

  @override
  List<Object?> get props => [];
}

class PropertyModerationInitial extends PropertyModerationState {
  const PropertyModerationInitial();
}

class PropertyModerationLoading extends PropertyModerationState {
  const PropertyModerationLoading();
}

class PropertyModerationLoaded extends PropertyModerationState {
  final List<PropertyQueueItem> items;
  const PropertyModerationLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class PropertyModerationError extends PropertyModerationState {
  final String message;
  const PropertyModerationError(this.message);

  @override
  List<Object?> get props => [message];
}
