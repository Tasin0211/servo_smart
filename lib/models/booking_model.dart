import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String bookingId;
  final String userId;
  final String userName;
  final String serviceType;
  final String providerId;
  final String providerName;
  final DateTime date;
  final int hours;
  final double hourlyRate;
  final double totalCost;
  final String status; // 'upcoming', 'ongoing', 'completed', 'cancelled'
  final DateTime createdAt;
  final double? rating;

  BookingModel({
    required this.bookingId,
    required this.userId,
    required this.userName,
    required this.serviceType,
    required this.providerId,
    required this.providerName,
    required this.date,
    required this.hours,
    required this.hourlyRate,
    required this.totalCost,
    required this.status,
    required this.createdAt,
    this.rating,
  });

  // Convert from Firestore document
  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      bookingId: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      serviceType: data['serviceType'] ?? '',
      providerId: data['providerId'] ?? '',
      providerName: data['providerName'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      hours: data['hours'] ?? 0,
      hourlyRate: (data['hourlyRate'] ?? 0).toDouble(),
      totalCost: (data['totalCost'] ?? 0).toDouble(),
      status: data['status'] ?? 'upcoming',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      rating: data['rating'] != null ? (data['rating'] as num).toDouble() : null,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'serviceType': serviceType,
      'providerId': providerId,
      'providerName': providerName,
      'date': Timestamp.fromDate(date),
      'hours': hours,
      'hourlyRate': hourlyRate,
      'totalCost': totalCost,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'rating': rating,
    };
  }

  // Copy with method for updates
  BookingModel copyWith({
    String? bookingId,
    String? userId,
    String? userName,
    String? serviceType,
    String? providerId,
    String? providerName,
    DateTime? date,
    int? hours,
    double? hourlyRate,
    double? totalCost,
    String? status,
    DateTime? createdAt,
    double? rating,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      serviceType: serviceType ?? this.serviceType,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      date: date ?? this.date,
      hours: hours ?? this.hours,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      totalCost: totalCost ?? this.totalCost,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
    );
  }
}
