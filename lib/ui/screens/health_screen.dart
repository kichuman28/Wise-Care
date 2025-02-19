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
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.softLight,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.topRight,
                              radius: 1.5,
                              colors: [
                                Colors.white.withOpacity(0.15),
                                Colors.white.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDoctorSection(),
                  const SizedBox(height: 24),
                  //_buildUpcomingAppointments(),
                  const SizedBox(height: 24),
                  //_buildHealthRecords(),
                ],
              ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
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
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _showBookingDialog(doctor),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text('Book Now'),
                    ),
                  ],
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

  Widget _buildUpcomingAppointments() {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, _) {
        if (bookingProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Appointments',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (bookingProvider.bookings.isEmpty)
              Center(
                child: Text(
                  'No upcoming appointments',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bookingProvider.bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookingProvider.bookings[index];
                  return _buildAppointmentCard(booking);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildAppointmentCard(Booking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          'Appointment with Dr. ${booking.doctorId}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(DateFormat('MMM dd, yyyy').format(booking.appointmentDate)),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(booking.timeSlot),
              ],
            ),
          ],
        ),
        trailing: booking.status == BookingStatus.pending
            ? TextButton(
                onPressed: () => context.read<BookingProvider>().cancelBooking(booking.id),
                child: const Text('Cancel'),
              )
            : null,
      ),
    );
  }

  Widget _buildHealthRecords() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Records',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildRecordCard(
              'Medical History',
              Icons.history,
              Colors.blue,
              () {},
            ),
            _buildRecordCard(
              'Lab Reports',
              Icons.science,
              Colors.green,
              () {},
            ),
            _buildRecordCard(
              'Prescriptions',
              Icons.receipt,
              Colors.orange,
              () {},
            ),
            _buildRecordCard(
              'Vaccinations',
              Icons.vaccines,
              Colors.purple,
              () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecordCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
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

    final booking = Booking(
      id: '',
      userId: context.read<AuthProvider>().uid,
      doctorId: doctor.id,
      appointmentDate: selectedDate,
      timeSlot: selectedTime,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
      consultationFee: doctor.consultationFee,
    );

    try {
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
          content: Text('Failed to book appointment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
