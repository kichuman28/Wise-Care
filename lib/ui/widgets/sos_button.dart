import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/services/sos_service.dart';

class SOSButton extends StatefulWidget {
  final Function(String)? onSOSActivated;
  final Function()? onSOSCancelled;

  const SOSButton({
    Key? key,
    this.onSOSActivated,
    this.onSOSCancelled,
  }) : super(key: key);

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  String? _currentAlertId;
  final SOSService _sosService = SOSService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleSOSPress() async {
    if (_isPressed) return;

    setState(() => _isPressed = true);
    _animationController.forward();

    try {
      // Show confirmation dialog
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Activate SOS Alert'),
          content: const Text(
            'Are you sure you want to activate the SOS alert? This will notify emergency responders of your situation.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Activate SOS'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        // Get current location
        final position = await _sosService.getCurrentLocation();

        // Create SOS alert
        final alertId = await _sosService.createSOSAlert(
          latitude: position.latitude,
          longitude: position.longitude,
          priority: 'high',
        );

        _currentAlertId = alertId;
        widget.onSOSActivated?.call(alertId);

        // Show active SOS alert dialog
        if (mounted) {
          _showActiveSOSDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to activate SOS: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  Future<void> _showActiveSOSDialog() async {
    if (_currentAlertId == null) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 8),
              const Text('SOS Alert Active'),
            ],
          ),
          content: StreamBuilder<DocumentSnapshot>(
  stream: _sosService.listenToSOSAlert(_currentAlertId!),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const CircularProgressIndicator();
    }

    final data = snapshot.data!.data() as Map<String, dynamic>;
    final status = data['status'] as String;
    final responder = data['responder'] as Map<String, dynamic>?;

    Widget content;
    switch (status) {
      case 'pending':
        content = const Text('Emergency services have been notified. Please wait...');
        break;
      case 'assigned':
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Help is on the way!'),
            if (responder != null) ...[
              const SizedBox(height: 16),
              Text('Responder: ${responder['name']}'),
              Text('Phone: ${responder['phone']}'),
            ],
          ],
        );
        break;
      case 'resolved':
        content = const Text('Emergency has been resolved.');
        break;
      default:
        content = const Text('Connecting to emergency services...');
    }

    return content;
  },
),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await _sosService.cancelSOSAlert(_currentAlertId!);
                  widget.onSOSCancelled?.call();
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to cancel SOS: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Cancel SOS'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _handleSOSPress(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'SOS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
