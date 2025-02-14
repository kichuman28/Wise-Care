import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/health_module_model.dart';
import '../widgets/health/vital_signs_card.dart';
import '../widgets/health/health_records_list.dart';
import '../widgets/health/diet_plan_card.dart';
import '../widgets/health/exercise_routine_card.dart';
import '../widgets/health/sleep_data_card.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: const Text('Health Dashboard'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Show modal to add new health data
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Stats Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQuickStat(
                            context,
                            'Heart Rate',
                            '72 BPM',
                            Icons.favorite,
                          ),
                          _buildQuickStat(
                            context,
                            'Blood Pressure',
                            '120/80',
                            Icons.speed,
                          ),
                          _buildQuickStat(
                            context,
                            'Temperature',
                            '98.6°F',
                            Icons.thermostat,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Vital Signs Section
                    Text(
                      'Vital Signs',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const VitalSignsCard(),
                    const SizedBox(height: 24),

                    // Health Records Section
                    Text(
                      'Health Records',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const HealthRecordsList(),
                    const SizedBox(height: 24),

                    // Diet Plan Section
                    Text(
                      'Diet Plan',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const DietPlanCard(),
                    const SizedBox(height: 24),

                    // Exercise Routine Section
                    Text(
                      'Exercise Routine',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const ExerciseRoutineCard(),
                    const SizedBox(height: 24),

                    // Sleep Data Section
                    Text(
                      'Sleep Analysis',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const SleepDataCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show modal to record new vital signs
        },
        child: const Icon(Icons.add_chart),
      ),
    );
  }

  Widget _buildQuickStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
} 