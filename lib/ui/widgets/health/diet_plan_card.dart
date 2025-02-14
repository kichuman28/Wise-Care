import 'package:flutter/material.dart';
import '../../../core/models/health_module_model.dart';

class DietPlanCard extends StatelessWidget {
  const DietPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          _buildCalorieProgress(context),
          const Divider(height: 1),
          _buildMealsList(context),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () {
                // Show dialog to modify diet plan
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Modify Diet Plan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Balanced Diet Plan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Customized for your health goals',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.green[700],
                ),
                const SizedBox(width: 4),
                Text(
                  'Active',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieProgress(BuildContext context) {
    const currentCalories = 1200;
    const targetCalories = 2000;
    final progress = currentCalories / targetCalories;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Calorie Intake',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                '$currentCalories / $targetCalories cal',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress < 0.8 ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsList(BuildContext context) {
    return Column(
      children: [
        _buildMealItem(
          context,
          'Breakfast',
          '8:00 AM',
          ['Oatmeal with fruits', 'Greek yogurt', 'Green tea'],
          350,
          Icons.wb_sunny_outlined,
          Colors.orange,
        ),
        const Divider(height: 1),
        _buildMealItem(
          context,
          'Lunch',
          '1:00 PM',
          ['Grilled chicken salad', 'Quinoa', 'Fresh juice'],
          450,
          Icons.sunny,
          Colors.green,
        ),
        const Divider(height: 1),
        _buildMealItem(
          context,
          'Dinner',
          '7:00 PM',
          ['Salmon', 'Steamed vegetables', 'Brown rice'],
          400,
          Icons.nights_stay_outlined,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildMealItem(
    BuildContext context,
    String mealName,
    String time,
    List<String> items,
    int calories,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            mealName,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.fiber_manual_record,
                      size: 8,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 8),
                    Text(item),
                  ],
                ),
              )),
          const SizedBox(height: 4),
          Text(
            '$calories calories',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
} 