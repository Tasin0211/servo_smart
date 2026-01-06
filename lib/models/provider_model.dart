import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProviderModel {
  final String providerId;
  final String name;
  final String serviceType; // 'cleaner', 'cook', 'plumber', 'electrician'
  final double hourlyRate;
  final double rating;
  final int totalReviews;
  final String imageUrl;
  final String description;

  ServiceProviderModel({
    required this.providerId,
    required this.name,
    required this.serviceType,
    required this.hourlyRate,
    required this.rating,
    required this.totalReviews,
    required this.imageUrl,
    required this.description,
  });

  // Convert from Firestore document
  factory ServiceProviderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceProviderModel(
      providerId: doc.id,
      name: data['name'] ?? '',
      serviceType: data['serviceType'] ?? '',
      hourlyRate: (data['hourlyRate'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'serviceType': serviceType,
      'hourlyRate': hourlyRate,
      'rating': rating,
      'totalReviews': totalReviews,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  // Copy with method for updates
  ServiceProviderModel copyWith({
    String? providerId,
    String? name,
    String? serviceType,
    double? hourlyRate,
    double? rating,
    int? totalReviews,
    String? imageUrl,
    String? description,
  }) {
    return ServiceProviderModel(
      providerId: providerId ?? this.providerId,
      name: name ?? this.name,
      serviceType: serviceType ?? this.serviceType,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }
}
