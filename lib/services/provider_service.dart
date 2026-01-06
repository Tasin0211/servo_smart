import '../models/provider_model.dart';
import 'firestore_service.dart';

class ProviderService {
  final FirestoreService _firestoreService = FirestoreService();

  // Get providers by service type
  Future<List<ServiceProviderModel>> getProvidersByServiceType(String serviceType) async {
    try {
      return await _firestoreService.getProvidersByServiceType(serviceType);
    } catch (e) {
      print('Error in getProvidersByServiceType: $e');
      rethrow;
    }
  }

  // Get a single provider
  Future<ServiceProviderModel?> getProvider(String providerId) async {
    try {
      return await _firestoreService.getProvider(providerId);
    } catch (e) {
      print('Error in getProvider: $e');
      rethrow;
    }
  }
}
