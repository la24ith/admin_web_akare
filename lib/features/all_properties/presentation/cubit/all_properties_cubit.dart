import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/property_list_row.dart';
import '../../domain/usecases/disable_property.dart';
import '../../domain/usecases/get_all_properties.dart';

part 'all_properties_state.dart';

class AllPropertiesCubit extends Cubit<AllPropertiesState> {
  final GetAllProperties getAllProperties;
  final DisableProperty disableProperty;

  PropertyStatusFilter _statusFilter = PropertyStatusFilter.all;
  String _searchQuery = '';
  Timer? _searchDebounce;

  AllPropertiesCubit({
    required this.getAllProperties,
    required this.disableProperty,
  }) : super(const AllPropertiesInitial());

  Future<void> load() async {
    emit(const AllPropertiesLoading());

    final result = await getAllProperties(GetAllPropertiesParams(
      status: _statusFilter.dbValue,
      searchQuery: _searchQuery.trim().isEmpty ? null : _searchQuery.trim(),
    ));

    result.fold(
      (failure) => emit(AllPropertiesError(failure.message)),
      (rows) => emit(AllPropertiesLoaded(
        rows: rows,
        statusFilter: _statusFilter,
        searchQuery: _searchQuery,
      )),
    );
  }

  void setStatusFilter(PropertyStatusFilter filter) {
    _statusFilter = filter;
    load();
  }

  /// بحث مع debounce (300ms) لتجنّب طلب لكل حرف يُكتب
  void setSearchQuery(String query) {
    _searchQuery = query;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), load);
  }

  Future<void> disable(String propertyId) async {
    final current = state;
    if (current is! AllPropertiesLoaded) return;

    emit(current.copyWith(disablingPropertyId: propertyId));

    final result = await disableProperty(DisablePropertyParams(propertyId));

    result.fold(
      (failure) => emit(AllPropertiesError(failure.message)),
      (_) => load(), // إعادة تحميل القائمة لتحديث الحالة والبادج
    );
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
