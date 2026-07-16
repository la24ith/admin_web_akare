import '../../domain/entities/property_list_row.dart';

class PropertyListRowModel extends PropertyListRow {
  const PropertyListRowModel({
    required super.id,
    required super.title,
    required super.price,
    required super.status,
    required super.agentName,
    required super.cityName,
    required super.imageUrl,
    required super.createdAt,
  });

  /// يتوقّع صف من:
  /// properties.select(
  ///   'id, title, price, status, created_at, '
  ///   'agents:agent_id(company_name, users:user_id(full_name)), '
  ///   'cities(name_ar), '
  ///   'property_images(image_url, is_primary)'
  /// )
  factory PropertyListRowModel.fromSupabase(Map<String, dynamic> row) {
    final agent = row['agents'] as Map<String, dynamic>?;
    final agentUser = agent?['users'] as Map<String, dynamic>?;
    final city = row['cities'] as Map<String, dynamic>?;
    final images = (row['property_images'] as List?) ?? const [];

    String? primaryImage;
    if (images.isNotEmpty) {
      final primary = images.firstWhere(
        (img) => img['is_primary'] == true,
        orElse: () => images.first,
      );
      primaryImage = primary['image_url'] as String?;
    }

    return PropertyListRowModel(
      id: row['id'] as String,
      title: row['title'] as String? ?? '',
      price: double.tryParse(row['price'].toString()) ?? 0,
      status: row['status'] as String? ?? 'pending',
      agentName: (agentUser?['full_name'] as String?) ??
          (agent?['company_name'] as String?) ??
          'وكيل غير معروف',
      cityName: (city?['name_ar'] as String?) ?? '',
      imageUrl: primaryImage,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
