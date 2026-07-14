import 'package:equatable/equatable.dart';

/// عنصر واحد بقائمة "بانتظار المراجعة" — /admin/properties/pending
class PropertyQueueItem extends Equatable {
  final String id;
  final String title;
  final double price;
  final String agentName;
  final String? imageUrl;
  final DateTime createdAt;

  const PropertyQueueItem({
    required this.id,
    required this.title,
    required this.price,
    required this.agentName,
    required this.imageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, price, agentName, imageUrl, createdAt];
}

/// مؤشر ثقة الوكيل المعروض بشاشة مراجعة التفاصيل
class AgentTrustInfo extends Equatable {
  final String agentId;
  final String agentName;
  final String? companyName;
  final String? licenseNumber;
  final bool isVerifiedAgent;
  final int approvedPropertiesCount;
  final int rejectedPropertiesCount;

  const AgentTrustInfo({
    required this.agentId,
    required this.agentName,
    required this.companyName,
    required this.licenseNumber,
    required this.isVerifiedAgent,
    required this.approvedPropertiesCount,
    required this.rejectedPropertiesCount,
  });

  @override
  List<Object?> get props => [
        agentId,
        agentName,
        companyName,
        licenseNumber,
        isVerifiedAgent,
        approvedPropertiesCount,
        rejectedPropertiesCount,
      ];
}

/// كل بيانات شاشة تفاصيل المراجعة — /admin/properties/pending/:id/review
class PropertyReviewDetail extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final String listingType; // 'sale' | 'rent'
  final String propertyTypeName;
  final String cityName;
  final String? addressText;
  final double? latitude;
  final double? longitude;
  final int? roomsCount;
  final int? bathroomsCount;
  final double areaSqm;
  final String status;
  final DateTime createdAt;
  final List<String> imageUrls;
  final AgentTrustInfo agent;

  const PropertyReviewDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.listingType,
    required this.propertyTypeName,
    required this.cityName,
    required this.addressText,
    required this.latitude,
    required this.longitude,
    required this.roomsCount,
    required this.bathroomsCount,
    required this.areaSqm,
    required this.status,
    required this.createdAt,
    required this.imageUrls,
    required this.agent,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        listingType,
        propertyTypeName,
        cityName,
        addressText,
        latitude,
        longitude,
        roomsCount,
        bathroomsCount,
        areaSqm,
        status,
        createdAt,
        imageUrls,
        agent,
      ];
}
