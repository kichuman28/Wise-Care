import 'package:flutter/material.dart';
import '../widgets/health/vital_signs_card.dart';
import '../widgets/health/medication_timeline.dart';
import '../widgets/health/daily_exercise_tracker.dart';
import '../widgets/health/sleep_quality_card.dart';
import '../widgets/health/upcoming_appointments.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Dashboard',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 24),
              const VitalSignsCard(),
              const SizedBox(height: 16),
              const MedicationTimeline(),
              const SizedBox(height: 16),
              const DailyExerciseTracker(),
              const SizedBox(height: 16),
              const SleepQualityCard(),
              const SizedBox(height: 16),
              const UpcomingAppointments(),
            ],
          ),
        ),
      ),
    );
  }
} 