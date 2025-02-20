import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/booking_provider.dart';
import '../../core/providers/doctor_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/models/booking_model.dart';
import '../../core/models/doctor_model.dart';
import '../screens/doctor_details_screen.dart';

class DoctorQuickActionButton extends StatefulWidget {
  const DoctorQuickActionButton({super.key});

  @override
  State<DoctorQuickActionButton> createState() => _DoctorQuickActionButtonState();
}

class _DoctorQuickActionButtonState extends State<DoctorQuickActionButton> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProvider>().loadDoctors();
    });
  }

  void _showDoctorsList(BuildContext context) {
    final userId = context.read<AuthProvider>().user?.uid;
    if (userId == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.medical_services),
                  const SizedBox(width: 12),
                  Text(
                    'Your Doctors',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Consumer2<BookingProvider?, DoctorProvider>(
                builder: (context, bookingProvider, doctorProvider, _) {
                  if (bookingProvider == null) {
                    return const Center(child: Text('Please log in to view your doctors'));
                  }

                  if (bookingProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final bookings = bookingProvider.bookings;
                  if (bookings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No doctor appointments yet',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/health');
                            },
                            child: const Text('Book an Appointment'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Get unique doctor IDs from bookings
                  final uniqueDoctorIds = bookings.map((b) => b.doctorId).toSet().toList();
                  final doctors = doctorProvider.doctors.where((d) => uniqueDoctorIds.contains(d.id)).toList();

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      final doctorBookings = bookings.where((b) => b.doctorId == doctor.id).toList()
                        ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
                      final lastBooking = doctorBookings.first;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorDetailsScreen(doctor: doctor),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      ),
                                      child: ClipOval(
                                        child: doctor.imageUrl.isNotEmpty
                                            ? Image.network(
                                                doctor.imageUrl,
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.cover,
                                                cacheWidth: 96, // 2x for high DPI displays
                                                cacheHeight: 96,
                                                errorBuilder: (context, error, stackTrace) => Icon(
                                                  Icons.person,
                                                  color: Theme.of(context).primaryColor,
                                                  size: 24,
                                                ),
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child: CircularProgressIndicator(
                                                        value: loadingProgress.expectedTotalBytes != null
                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                loadingProgress.expectedTotalBytes!
                                                            : null,
                                                        strokeWidth: 2,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Icon(
                                                Icons.person,
                                                color: Theme.of(context).primaryColor,
                                                size: 24,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doctor.name,
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            doctor.specialization,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${doctorBookings.length} visits',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Last Visit',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.event,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${lastBooking.appointmentDate.day}/${lastBooking.appointmentDate.month}/${lastBooking.appointmentDate.year}',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      lastBooking.timeSlot,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showDoctorsList(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.medical_services,
                color: Theme.of(context).primaryColor,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'My Doctors',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 4),
              Consumer<BookingProvider?>(
                builder: (context, bookingProvider, _) {
                  if (bookingProvider == null || bookingProvider.isLoading) {
                    return Text(
                      '...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    );
                  }

                  final uniqueDoctors = bookingProvider.bookings.map((b) => b.doctorId).toSet().length;

                  return Text(
                    '$uniqueDoctors doctors',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
