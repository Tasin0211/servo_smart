import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/service_provider_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/provider_card.dart';
import '../../widgets/loading_indicator.dart';
import '../booking/booking_screen.dart';

class ServiceListScreen extends StatefulWidget {
  final String serviceType;

  const ServiceListScreen({
    super.key,
    required this.serviceType,
  });

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProviders();
    });
  }

  Future<void> _loadProviders() async {
    final providerProvider = Provider.of<ServiceProviderProvider>(context, listen: false);
    await providerProvider.loadProvidersByServiceType(widget.serviceType);
  }

  @override
  Widget build(BuildContext context) {
    final serviceName = ServiceTypes.serviceNames[widget.serviceType] ?? widget.serviceType;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          '$serviceName Services',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<ServiceProviderProvider>(
        builder: (context, providerProvider, child) {
          if (providerProvider.isLoading) {
            return const Center(
              child: LoadingIndicator(message: 'Loading providers...'),
            );
          }

          if (providerProvider.providers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  const Text(
                    'No providers available',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  const Text(
                    'Please check back later',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadProviders,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
              itemCount: providerProvider.providers.length,
              itemBuilder: (context, index) {
                final provider = providerProvider.providers[index];
                return ProviderCard(
                  provider: provider,
                  onSelect: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(provider: provider),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
