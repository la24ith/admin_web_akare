import 'package:admin_web/features/property_moderation/domin/entities/property_moderation_entities.dart';

class PropertyQueueItemModel extends PropertyQueueItem {
  const PropertyQueueItemModel({
    required super.id,
    required super.title,
    required super.price,
    required super.agentName,
    required super.imageUrl,
    required super.createdAt,
  });

  /// يتوقّع صف من:
  /// properties.select(
  ///   'id, title, price, created_at, '
  ///   'agents:agent_id(company_name, users:user_id(full_name)), '
  ///   'property_images(image_url, is_primary)'
  /// ).eq('status','pending').order('created_at')
  factory PropertyQueueItemModel.fromSupabase(Map<String, dynamic> row) {
    final agent = row['agents'] as Map<String, dynamic>?;
    final agentUser = agent?['users'] as Map<String, dynamic>?;
    final images = (row['property_images'] as List?) ?? const [];

    String? primaryImage;
    if (images.isNotEmpty) {
      final primary = images.firstWhere(
        (img) => img['is_primary'] == true,
        orElse: () => images.first,
      );
      primaryImage = primary['image_url'] as String?;
    }

    return PropertyQueueItemModel(
      id: row['id'] as String,
      title: row['title'] as String? ?? '',
      price: double.tryParse(row['price'].toString()) ?? 0,
      agentName: (agentUser?['full_name'] as String?) ??
          (agent?['company_name'] as String?) ??
          'وكيل غير معروف',
      imageUrl: primaryImage,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}

class AgentTrustInfoModel extends AgentTrustInfo {
  const AgentTrustInfoModel({
    required super.agentId,
    required super.agentName,
    required super.companyName,
    required super.licenseNumber,
    required super.isVerifiedAgent,
    required super.approvedPropertiesCount,
    required super.rejectedPropertiesCount,
  });
}

class PropertyReviewDetailModel extends PropertyReviewDetail {
  const PropertyReviewDetailModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.listingType,
    required super.propertyTypeName,
    required super.cityName,
    required super.addressText,
    required super.latitude,
    required super.longitude,
    required super.roomsCount,
    required super.bathroomsCount,
    required super.areaSqm,
    required super.status,
    required super.createdAt,
    required super.imageUrls,
    required super.agent,
  });

  /// يتوقّع صف من:
  /// properties.select(
  ///   'id, title, description, price, listing_type, address_text, latitude, '
  ///   'longitude, rooms_count, bathrooms_count, area_sqm, status, created_at, '
  ///   'property_types(name_ar), cities(name_ar), '
  ///   'agents:agent_id(id, company_name, license_number, is_verified_agent, '
  ///   'users:user_id(full_name)), '
  ///   'property_images(image_url, sort_order)'
  /// ).eq('id', propertyId).single()
  ///
  /// [approvedCount] و[rejectedCount] يُمرَّران منفصلين لأنهم بيجيّن من استعلامَين
  /// إضافيَّين على جدول properties بنفس agent_id.
  factory PropertyReviewDetailModel.fromSupabase(
    Map<String, dynamic> row, {
    required int approvedCount,
    required int rejectedCount,
  }) {
    final propertyType = row['property_types'] as Map<String, dynamic>?;
    final city = row['cities'] as Map<String, dynamic>?;
    final agent = row['agents'] as Map<String, dynamic>?;
    final agentUser = agent?['users'] as Map<String, dynamic>?;
    final images = (row['property_images'] as List?) ?? const [];

    final sortedImages = [...images]..sort((a, b) =>
        ((a['sort_order'] as int?) ?? 0)
            .compareTo((b['sort_order'] as int?) ?? 0));

    return PropertyReviewDetailModel(
      id: row['id'] as String,
      title: row['title'] as String? ?? '',
      description: row['description'] as String? ?? '',
      price: double.tryParse(row['price'].toString()) ?? 0,
      listingType: row['listing_type'] as String? ?? 'sale',
      propertyTypeName: (propertyType?['name_ar'] as String?) ?? '',
      cityName: (city?['name_ar'] as String?) ?? '',
      addressText: row['address_text'] as String?,
      latitude: row['latitude'] != null
          ? double.tryParse(row['latitude'].toString())
          : null,
      longitude: row['longitude'] != null
          ? double.tryParse(row['longitude'].toString())
          : null,
      roomsCount: row['rooms_count'] as int?,
      bathroomsCount: row['bathrooms_count'] as int?,
      areaSqm: double.tryParse(row['area_sqm'].toString()) ?? 0,
      status: row['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(row['created_at'] as String),
      imageUrls: sortedImages
          .map((img) => img['image_url'] as String)
          .toList(growable: false),
      agent: AgentTrustInfoModel(
        agentId: agent?['id'] as String? ?? '',
        agentName: (agentUser?['full_name'] as String?) ?? 'وكيل غير معروف',
        companyName: agent?['company_name'] as String?,
        licenseNumber: agent?['license_number'] as String?,
        isVerifiedAgent: agent?['is_verified_agent'] as bool? ?? false,
        approvedPropertiesCount: approvedCount,
        rejectedPropertiesCount: rejectedCount,
      ),
    );
  }
}
