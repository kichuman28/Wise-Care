import 'package:flutter/material.dart';
import '../../../core/models/health_module_model.dart';

class ExerciseRoutineCard extends StatelessWidget {
  const ExerciseRoutineCard({super.key});

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
          _buildProgressSection(context),
          const Divider(height: 1),
          _buildExerciseList(context),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () {
                // Show dialog to start workout
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Start Workout'),
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
                'Daily Exercise Routine',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Gentle exercises for seniors',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 16,
                  color: Colors.blue[700],
                ),
                const SizedBox(width: 4),
                Text(
                  'Beginner',
                  style: TextStyle(
                    color: Colors.blue[700],
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

  Widget _buildProgressSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildProgressStat(
            context,
            'Duration',
            '30 min',
            Icons.timer,
            Colors.blue,
          ),
          _buildProgressStat(
            context,
            'Exercises',
            '6',
            Icons.fitness_center,
            Colors.green,
          ),
          _buildProgressStat(
            context,
            'Completed',
            '2/6',
            Icons.check_circle,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildExerciseList(BuildContext context) {
    return Column(
      children: [
        _buildExerciseItem(
          context,
          'Gentle Walking',
          '10 minutes',
          'Warm up with a gentle walk',
          true,
          Icons.directions_walk,
        ),
        const Divider(height: 1),
        _buildExerciseItem(
          context,
          'Chair Squats',
          '3 sets x 8 reps',
          'Stand up and sit down using a chair',
          true,
          Icons.chair,
        ),
        const Divider(height: 1),
        _buildExerciseItem(
          context,
          'Arm Circles',
          '2 sets x 30 seconds',
          'Make circular motions with your arms',
          false,
          Icons.rotate_right,
        ),
      ],
    );
  }

  Widget _buildExerciseItem(
    BuildContext context,
    String name,
    String duration,
    String description,
    bool isCompleted,
    IconData icon,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
            ),
          ),
          if (isCompleted)
            Icon(
              Icons.check_circle,
              color: Colors.green[700],
              size: 20,
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            duration,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.play_circle_outline),
        onPressed: () {
          // Show exercise details or video
        },
      ),
    );
  }
} 