import 'package:flutter/foundation.dart';
import '../models/provider_model.dart';
import '../services/provider_service.dart';

class ServiceProviderProvider with ChangeNotifier {
  final ProviderService _providerService = ProviderService();
  List<ServiceProviderModel> _providers = [];
  bool _isLoading = false;

  List<ServiceProviderModel> get providers => _providers;
  bool get isLoading => _isLoading;

  // Load providers by service type
  Future<void> loadProvidersByServiceType(String serviceType) async {
    try {
      _isLoading = true;
      notifyListeners();

      _providers = await _providerService.getProvidersByServiceType(serviceType);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error loading providers: $e');
    }
  }

  // Get single provider
  Future<ServiceProviderModel?> getProvider(String providerId) async {
    try {
      return await _providerService.getProvider(providerId);
    } catch (e) {
      print('Error getting provider: $e');
      return null;
    }
  }

  // Clear providers
  void clearProviders() {
    _providers = [];
    notifyListeners();
  }
}
