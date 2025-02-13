import 'package:flutter/material.dart';
import '../widgets/community/local_events_card.dart';
import '../widgets/community/activity_groups.dart';
import '../widgets/community/help_exchange_board.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

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
                'Community',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 24),
              const LocalEventsCard(),
              const SizedBox(height: 16),
              const ActivityGroups(),
              const SizedBox(height: 16),
              const HelpExchangeBoard(),
            ],
          ),
        ),
      ),
    );
  }
} 