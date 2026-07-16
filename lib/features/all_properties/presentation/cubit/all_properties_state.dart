part of 'all_properties_cubit.dart';

abstract class AllPropertiesState extends Equatable {
  const AllPropertiesState();

  @override
  List<Object?> get props => [];
}

class AllPropertiesInitial extends AllPropertiesState {
  const AllPropertiesInitial();
}

class AllPropertiesLoading extends AllPropertiesState {
  const AllPropertiesLoading();
}

class AllPropertiesLoaded extends AllPropertiesState {
  final List<PropertyListRow> rows;
  final PropertyStatusFilter statusFilter;
  final String searchQuery;

  /// أثناء تنفيذ "تعطيل فوري" على صف معيّن — لعرض مؤشر تحميل صغير جواه بس.
  final String? disablingPropertyId;

  const AllPropertiesLoaded({
    required this.rows,
    required this.statusFilter,
    required this.searchQuery,
    this.disablingPropertyId,
  });

  AllPropertiesLoaded copyWith({
    List<PropertyListRow>? rows,
    PropertyStatusFilter? statusFilter,
    String? searchQuery,
    String? disablingPropertyId,
    bool clearDisabling = false,
  }) {
    return AllPropertiesLoaded(
      rows: rows ?? this.rows,
      statusFilter: statusFilter ?? this.statusFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      disablingPropertyId:
          clearDisabling ? null : (disablingPropertyId ?? this.disablingPropertyId),
    );
  }

  @override
  List<Object?> get props =>
      [rows, statusFilter, searchQuery, disablingPropertyId];
}

class AllPropertiesError extends AllPropertiesState {
  final String message;
  const AllPropertiesError(this.message);

  @override
  List<Object?> get props => [message];
}
