import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/greeting_header.dart';
import '../widgets/sos_button.dart';
import '../widgets/medicine_quick_action_button.dart';
import '../widgets/doctor_quick_action_button.dart';
import '../widgets/order_medicine_quick_action_button.dart';
import '../widgets/family_quick_action_button.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authProvider.user == null) {
          return const Scaffold(
            body: Center(
              child: Text('Please log in to continue'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GreetingHeader(),
                  const SizedBox(height: 32),

                  // Emergency SOS Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            'Emergency Help',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Press and hold for emergency assistance',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 24),
                          const SOSButton(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Quick Actions
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: const [
                      DoctorQuickActionButton(),
                      MedicineQuickActionButton(),
                      OrderMedicineQuickActionButton(),
                      FamilyQuickActionButton(),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Health Overview
                  Text(
                    'Health Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        _buildHealthMetric(
                          context,
                          'Blood Pressure',
                          '120/80',
                          Icons.favorite_rounded,
                        ),
                        const Divider(height: 1),
                        _buildHealthMetric(
                          context,
                          'Heart Rate',
                          '72 BPM',
                          Icons.timeline_rounded,
                        ),
                        const Divider(height: 1),
                        _buildHealthMetric(
                          context,
                          'Steps Today',
                          '2,547',
                          Icons.directions_walk_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthMetric(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
