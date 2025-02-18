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
      builder: (context) => AlertDialog(
        title: const Text('SOS Alert Active'),
        content: StreamBuilder<DocumentSnapshot>(
          stream: _sosService.listenToSOSAlert(_currentAlertId!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final status = data['status'] as String;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_getStatusMessage(status)),
                const SizedBox(height: 16),
                if (data['assignedTo'] != null) ...[
                  const Text(
                    'Help is on the way!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (data['responder'] != null) ...[
                    Text('Responder: ${data['responder']['name']}'),
                    Text('Phone: ${data['responder']['phone']}'),
                  ],
                ],
              ],
            );
          },
        ),
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: _sosService.listenToSOSAlert(_currentAlertId!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();

              final data = snapshot.data!.data() as Map<String, dynamic>;
              final status = data['status'] as String;

              if (status == 'resolved') {
                return TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onSOSCancelled?.call();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                  child: const Text('Close'),
                );
              }

              return TextButton(
                onPressed: () => _showCancellationWarning(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Cancel SOS'),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showCancellationWarning(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Warning',
          style: TextStyle(color: Colors.red),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to cancel the SOS alert?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Only cancel if:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildWarningPoint('The emergency situation is resolved'),
            _buildWarningPoint('You activated SOS by mistake'),
            _buildWarningPoint('You no longer need emergency assistance'),
            const SizedBox(height: 16),
            const Text(
              'If you are still in danger, do NOT cancel the alert!',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep Active'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Yes, Cancel SOS'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _cancelSOS();
      Navigator.of(context).pop(); // Close the active SOS dialog
    }
  }

  Widget _buildWarningPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Future<void> _cancelSOS() async {
    try {
      await _sosService.cancelSOSAlert(_currentAlertId!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SOS alert has been cancelled'),
            backgroundColor: Colors.orange,
          ),
        );
        widget.onSOSCancelled?.call();
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
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'pending':
        return 'Emergency services have been notified. Please wait...';
      case 'assigned':
        return 'A responder has been assigned to help you.';
      case 'resolved':
        return 'Emergency has been resolved. You can now close this dialog.';
      case 'cancelled':
        return 'Alert has been cancelled.';
      default:
        return 'Processing your emergency alert...';
    }
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
