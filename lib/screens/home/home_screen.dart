import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/service_card.dart';
import '../service_list/service_list_screen.dart';
import '../upcoming/upcoming_screen.dart';
import '../completed/completed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeTab(),
    const UpcomingScreen(),
    const CompletedScreen(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upcoming),
            label: AppStrings.upcoming,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: AppStrings.completed,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.user?.name ?? 'User';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                'Hello, $userName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              const Text(
                AppStrings.selectService,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              // Service Cards Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppDimensions.paddingMedium,
                  mainAxisSpacing: AppDimensions.paddingMedium,
                  children: [
                    ServiceCard(
                      serviceType: ServiceTypes.cleaner,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ServiceListScreen(
                              serviceType: ServiceTypes.cleaner,
                            ),
                          ),
                        );
                      },
                    ),
                    ServiceCard(
                      serviceType: ServiceTypes.cook,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ServiceListScreen(
                              serviceType: ServiceTypes.cook,
                            ),
                          ),
                        );
                      },
                    ),
                    ServiceCard(
                      serviceType: ServiceTypes.plumber,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ServiceListScreen(
                              serviceType: ServiceTypes.plumber,
                            ),
                          ),
                        );
                      },
                    ),
                    ServiceCard(
                      serviceType: ServiceTypes.electrician,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ServiceListScreen(
                              serviceType: ServiceTypes.electrician,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.profile,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            children: [
              // Profile Card
              Card(
                elevation: AppDimensions.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                        child: Text(
                          user?.name.isNotEmpty == true
                              ? user!.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      Text(
                        user?.name ?? 'User',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingSmall),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              // Logout Button
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: AppColors.errorColor,
                ),
                title: const Text(
                  AppStrings.logout,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.errorColor,
                  ),
                ),
                onTap: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: AppColors.errorColor),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    await authProvider.signOut();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
