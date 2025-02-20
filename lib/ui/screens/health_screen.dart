import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../core/providers/doctor_provider.dart';
import '../../core/providers/booking_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/models/doctor_model.dart';
import '../../core/models/booking_model.dart';
import 'package:intl/intl.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProvider>().loadDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Health Dashboard'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                      Theme.of(context).primaryColor.withOpacity(0.6),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildDoctorSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorSection() {
    return Consumer<DoctorProvider>(
      builder: (context, doctorProvider, _) {
        if (doctorProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Doctors',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to all doctors
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 420, // Increased from 320 to 420 to accommodate all content
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: doctorProvider.doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctorProvider.doctors[index];
                  return _buildDoctorCard(doctor);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => _showBookingDialog(doctor),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(doctor.imageUrl),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: doctor.imageUrl.isEmpty
                          ? Icon(Icons.person, size: 30, color: Theme.of(context).primaryColor)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doctor.specialization,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber[700]),
                              const SizedBox(width: 4),
                              Text(
                                doctor.rating.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  doctor.about,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoColumn(
                      '${doctor.experience}+',
                      'Years',
                      Icons.work,
                    ),
                    Container(
                      height: 24,
                      width: 1,
                      color: Colors.grey[300],
                    ),
                    _buildInfoColumn(
                      '${doctor.patientsServed}+',
                      'Patients',
                      Icons.people,
                    ),
                    Container(
                      height: 24,
                      width: 1,
                      color: Colors.grey[300],
                    ),
                    _buildInfoColumn(
                      '₹${doctor.consultationFee}',
                      'Fee',
                      Icons.payments_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Increased spacing
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16), // Adjusted padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Available',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: doctor.availableDays
                            .take(3)
                            .map((day) => Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    day.substring(0, 3),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16), // Increased spacing
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showBookingDialog(doctor),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Book Now'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String value, String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).primaryColor),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Future<void> _showBookingDialog(Doctor doctor) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (selectedDate == null || !mounted) return;

    final availableSlots = doctor.availableTimeSlots[DateFormat('EEEE').format(selectedDate)] ?? [];

    if (!mounted) return;

    final selectedTime = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Time'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableSlots.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(availableSlots[index]),
                onTap: () => Navigator.pop(context, availableSlots[index]),
              );
            },
          ),
        ),
      ),
    );

    if (selectedTime == null || !mounted) return;

    try {
      final userId = context.read<AuthProvider>().user?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final booking = Booking(
        id: '', // Will be set by Firebase
        userId: userId,
        doctorId: doctor.id,
        appointmentDate: selectedDate,
        timeSlot: selectedTime,
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
        consultationFee: doctor.consultationFee,
        notes: null,
      );

      await context.read<BookingProvider>().createBooking(booking);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment booked successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book appointment: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
