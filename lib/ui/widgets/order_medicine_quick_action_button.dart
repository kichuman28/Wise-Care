import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/prescription_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/order_provider.dart';
import '../../core/providers/user_address_provider.dart';
import '../../core/models/prescription_model.dart';
import '../../core/models/order_model.dart';
import '../../core/models/user_address_model.dart';
import '../../core/services/sos_service.dart';
import 'package:intl/intl.dart';
import 'quick_action_button.dart';

class OrderMedicineQuickActionButton extends StatefulWidget {
  const OrderMedicineQuickActionButton({Key? key}) : super(key: key);

  @override
  State<OrderMedicineQuickActionButton> createState() =>
      _OrderMedicineQuickActionButtonState();
}

class _OrderMedicineQuickActionButtonState
    extends State<OrderMedicineQuickActionButton> {
  final Map<String, bool> _selectedMedicines = {};
  final Map<String, int> _medicineDays = {};
  final Map<String, int> _medicineQuantities = {};
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  int _calculateQuantity(String frequency, int days) {
    // Parse frequency string to get daily doses
    int dailyDoses = 1; // Default to once a day
    if (frequency.toLowerCase().contains('twice')) {
      dailyDoses = 2;
    } else if (frequency.toLowerCase().contains('thrice') ||
        frequency.toLowerCase().contains('three times')) {
      dailyDoses = 3;
    } else if (frequency.toLowerCase().contains('four times')) {
      dailyDoses = 4;
    }
    return dailyDoses * days;
  }

  void _showAddressSelectionDialog(BuildContext context, String userId,
      Function(String?) onAddressSelected) {
    final addressProvider = context.read<UserAddressProvider?>();

    if (addressProvider == null) {
      onAddressSelected(null);
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Delivery Address'),
              content: SizedBox(
                width: double.maxFinite,
                child: addressProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : addressProvider.addresses.isEmpty
                        ? const Text(
                            'No saved addresses. Please add a new address.')
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Select a delivery address:'),
                              const SizedBox(height: 8),
                              ...addressProvider.addresses.map((address) {
                                return Column(
                                  children: [
                                    RadioListTile<String>(
                                      title: Text(address.address),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (address.additionalInfo != null)
                                            Text(address.additionalInfo!),
                                          if (address.latitude != null &&
                                              address.longitude != null)
                                            Text(
                                              'Location: ${address.latitude!.toStringAsFixed(6)}, ${address.longitude!.toStringAsFixed(6)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                        ],
                                      ),
                                      value: address.id!,
                                      groupValue:
                                          addressProvider.selectedAddress?.id,
                                      onChanged: (value) {
                                        if (value != null) {
                                          final selectedAddress =
                                              addressProvider.addresses
                                                  .firstWhere(
                                            (a) => a.id == value,
                                          );
                                          addressProvider
                                              .selectAddress(selectedAddress);
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    const Divider(),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showAddAddressDialog(context, userId, onAddressSelected);
                  },
                  child: const Text('Add New Address'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onAddressSelected(null);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: addressProvider.selectedAddress != null
                      ? () {
                          Navigator.pop(context);
                          onAddressSelected(
                              addressProvider.selectedAddress!.id);
                        }
                      : null,
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddAddressDialog(BuildContext context, String userId,
      Function(String?) onAddressSelected) {
    _addressController.clear();
    _additionalInfoController.clear();

    bool _isLoadingLocation = false;
    double? _latitude;
    double? _longitude;
    final _sosService = SOSService();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Address'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        hintText: 'Enter your full address',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _additionalInfoController,
                      decoration: const InputDecoration(
                        labelText: 'Additional Information (Optional)',
                        hintText: 'Apartment number, landmark, etc.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _latitude != null && _longitude != null
                                ? 'Location: ${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}'
                                : 'Location: Not fetched',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        _isLoadingLocation
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : IconButton(
                                icon: const Icon(Icons.my_location),
                                tooltip: 'Get current location',
                                onPressed: () async {
                                  setState(() {
                                    _isLoadingLocation = true;
                                  });

                                  try {
                                    final position =
                                        await _sosService.getCurrentLocation();
                                    setState(() {
                                      _latitude = position.latitude;
                                      _longitude = position.longitude;
                                      _isLoadingLocation = false;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      _isLoadingLocation = false;
                                    });

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Failed to get location: ${e.toString().replaceAll('Exception: ', '')}'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onAddressSelected(null);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_addressController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter an address'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final addressProvider =
                        context.read<UserAddressProvider?>();
                    if (addressProvider != null) {
                      try {
                        final newAddress = UserAddress(
                          userId: userId,
                          address: _addressController.text.trim(),
                          additionalInfo:
                              _additionalInfoController.text.trim().isNotEmpty
                                  ? _additionalInfoController.text.trim()
                                  : null,
                          latitude: _latitude,
                          longitude: _longitude,
                          isDefault: addressProvider.addresses
                              .isEmpty, // Make default if first address
                        );

                        // Add the address and get the ID
                        final String addressId =
                            await addressProvider.addAddress(newAddress);

                        if (mounted) {
                          Navigator.pop(context);
                          // Pass the address ID instead of the address text
                          onAddressSelected(addressId);
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error adding address: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    } else {
                      Navigator.pop(context);
                      onAddressSelected(null);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showOrderMedicinesList(BuildContext context) {
    final userId = context.read<AuthProvider>().user?.uid;
    if (userId == null) return;

    // Check if user has a saved address
    final addressProvider = context.read<UserAddressProvider?>();
    if (addressProvider != null && addressProvider.addresses.isEmpty) {
      // No saved address, prompt to add one first
      _showAddAddressDialog(context, userId, (addressId) {
        if (addressId != null) {
          // Now show the medicine order dialog
          _showOrderMedicinesBottomSheet(context, userId);
        }
      });
    } else if (addressProvider != null &&
        addressProvider.selectedAddress != null) {
      // Has a saved address, show selection dialog
      _showAddressSelectionDialog(context, userId, (addressId) {
        if (addressId != null) {
          // Address selected, show the medicine order dialog
          _showOrderMedicinesBottomSheet(context, userId);
        }
      });
    } else {
      // No address provider or error, just show the medicine order dialog
      _showOrderMedicinesBottomSheet(context, userId);
    }
  }

  void _showOrderMedicinesBottomSheet(BuildContext context, String userId) {
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
        builder: (context, scrollController) => StatefulBuilder(
          builder: (context, setBottomSheetState) => Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Order Medicines',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              // Display selected address if available
              Consumer<UserAddressProvider?>(
                builder: (context, addressProvider, child) {
                  if (addressProvider != null &&
                      addressProvider.selectedAddress != null) {
                    final selectedAddress = addressProvider.selectedAddress!;
                    return Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.grey[100],
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivery Address:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                                Text(
                                  selectedAddress.address,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                if (selectedAddress.additionalInfo != null)
                                  Text(
                                    selectedAddress.additionalInfo!,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                if (selectedAddress.latitude != null &&
                                    selectedAddress.longitude != null)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.my_location,
                                        size: 12,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'GPS: ${selectedAddress.latitude!.toStringAsFixed(6)}, ${selectedAddress.longitude!.toStringAsFixed(6)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontSize: 10,
                                                color: Colors.grey[600],
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showAddressSelectionDialog(context, userId,
                                  (addressId) {
                                if (addressId != null) {
                                  _showOrderMedicinesBottomSheet(
                                      context, userId);
                                }
                              });
                            },
                            child: const Text('Change'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Expanded(
                child: StreamBuilder<List<Prescription>>(
                  stream: context
                      .read<PrescriptionProvider>()
                      .getUserPrescriptionsStream(userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final prescriptions = snapshot.data?.where((prescription) {
                      // Filter active prescriptions (less than 30 days old)
                      final thirtyDaysAgo =
                          DateTime.now().subtract(const Duration(days: 30));
                      return prescription.createdAt.isAfter(thirtyDaysAgo);
                    }).toList();

                    if (prescriptions == null || prescriptions.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medication_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No active prescriptions found',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Visit a doctor to get new prescriptions',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: prescriptions.length,
                            itemBuilder: (context, index) {
                              final prescription = prescriptions[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              prescription.diagnosis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            DateFormat('MMM d, yyyy')
                                                .format(prescription.createdAt),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Colors.grey[600],
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            prescription.medicines.length,
                                        itemBuilder: (context, medicineIndex) {
                                          final medicine = prescription
                                              .medicines[medicineIndex];
                                          final medicineId =
                                              '${prescription.id}_${medicine.name}';

                                          // Initialize days if not set
                                          _medicineDays[medicineId] ??= 30;
                                          // Calculate quantity based on frequency and days
                                          _medicineQuantities[medicineId] =
                                              _calculateQuantity(
                                            medicine.frequency,
                                            _medicineDays[medicineId]!,
                                          );

                                          return StatefulBuilder(
                                            builder: (context, setInnerState) {
                                              return Column(
                                                children: [
                                                  CheckboxListTile(
                                                    value: _selectedMedicines[
                                                            medicineId] ??
                                                        false,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        _selectedMedicines[
                                                                medicineId] =
                                                            value ?? false;
                                                      });
                                                      setInnerState(() {});
                                                      setBottomSheetState(
                                                          () {});
                                                    },
                                                    title: Text(
                                                      medicine.name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall,
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Dosage: ${medicine.dosage} | Frequency: ${medicine.frequency}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                        ),
                                                        if (_selectedMedicines[
                                                                medicineId] ==
                                                            true) ...[
                                                          const SizedBox(
                                                              height: 8),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Days supply:',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              IconButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .remove_circle_outline),
                                                                onPressed:
                                                                    _medicineDays[medicineId]! >
                                                                            1
                                                                        ? () {
                                                                            setState(() {
                                                                              _medicineDays[medicineId] = _medicineDays[medicineId]! - 1;
                                                                              _medicineQuantities[medicineId] = _calculateQuantity(
                                                                                medicine.frequency,
                                                                                _medicineDays[medicineId]!,
                                                                              );
                                                                            });
                                                                            setInnerState(() {});
                                                                          }
                                                                        : null,
                                                              ),
                                                              Text(
                                                                '${_medicineDays[medicineId]} days',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium,
                                                              ),
                                                              IconButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .add_circle_outline),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _medicineDays[
                                                                            medicineId] =
                                                                        _medicineDays[medicineId]! +
                                                                            1;
                                                                    _medicineQuantities[
                                                                            medicineId] =
                                                                        _calculateQuantity(
                                                                      medicine
                                                                          .frequency,
                                                                      _medicineDays[
                                                                          medicineId]!,
                                                                    );
                                                                  });
                                                                  setInnerState(
                                                                      () {});
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            'Total quantity: ${_medicineQuantities[medicineId]} units',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                    dense: true,
                                                  ),
                                                  if (medicineIndex <
                                                      prescription.medicines
                                                              .length -
                                                          1)
                                                    const Divider(height: 1),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (_selectedMedicines.values
                            .any((selected) => selected))
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    // Check if address is selected
                                    final addressProvider =
                                        context.read<UserAddressProvider?>();
                                    if (addressProvider == null ||
                                        addressProvider.selectedAddress ==
                                            null) {
                                      throw Exception(
                                          'Please select a delivery address');
                                    }

                                    // Show loading indicator
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );

                                    final selectedMedicines = <OrderMedicine>[];
                                    double totalAmount = 0;

                                    // Validate if any medicines are selected
                                    if (!_selectedMedicines.values
                                        .any((selected) => selected)) {
                                      throw Exception(
                                          'Please select at least one medicine to order');
                                    }

                                    for (final prescription in prescriptions) {
                                      for (final medicine
                                          in prescription.medicines) {
                                        final medicineId =
                                            '${prescription.id}_${medicine.name}';
                                        if (_selectedMedicines[medicineId] ==
                                            true) {
                                          if (_medicineDays[medicineId] ==
                                                  null ||
                                              _medicineDays[medicineId]! <= 0) {
                                            throw Exception(
                                                'Invalid days supply for ${medicine.name}');
                                          }

                                          final quantity =
                                              _medicineQuantities[medicineId];
                                          if (quantity == null ||
                                              quantity <= 0) {
                                            throw Exception(
                                                'Invalid quantity for ${medicine.name}');
                                          }

                                          // Assuming a dummy price of $1 per unit for now
                                          const pricePerUnit = 1.0;
                                          final totalPrice =
                                              pricePerUnit * quantity;
                                          totalAmount += totalPrice;

                                          selectedMedicines.add(
                                            OrderMedicine(
                                              medicineId: medicineId,
                                              medicineName: medicine.name,
                                              dosage: medicine.dosage,
                                              frequency: medicine.frequency,
                                              daysSupply:
                                                  _medicineDays[medicineId]!,
                                              quantity: quantity,
                                              pricePerUnit: pricePerUnit,
                                              totalPrice: totalPrice,
                                            ),
                                          );
                                        }
                                      }
                                    }

                                    // Validate if we have any medicines to order
                                    if (selectedMedicines.isEmpty) {
                                      throw Exception(
                                          'No medicines selected for order');
                                    }

                                    final order = Order(
                                      userId: userId,
                                      prescriptionId: prescriptions.first.id!,
                                      medicines: selectedMedicines,
                                      orderDate: DateTime.now(),
                                      status: 'pending',
                                      totalAmount: totalAmount,
                                      addressId:
                                          addressProvider.selectedAddress!.id,
                                    );

                                    // Create the order in Firebase
                                    await context
                                        .read<OrderProvider>()
                                        .createOrder(order);

                                    if (mounted) {
                                      // Close loading indicator
                                      Navigator.pop(context);

                                      // Show success message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Order placed successfully!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      // Clear selection
                                      setState(() {
                                        _selectedMedicines.clear();
                                        _medicineDays.clear();
                                        _medicineQuantities.clear();
                                      });

                                      // Close bottom sheet
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      // Close loading indicator if it's showing
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }

                                      // Show error message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(e
                                              .toString()
                                              .replaceAll('Exception: ', '')),
                                          backgroundColor: Colors.red,
                                          duration: const Duration(seconds: 5),
                                          action: SnackBarAction(
                                            label: 'OK',
                                            textColor: Colors.white,
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Place Order'),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrescriptionProvider?>(
      builder: (context, provider, child) {
        final isLoading = provider == null || provider.isLoading;
        final activePrescriptions = isLoading
            ? 0
            : provider.prescriptions.where((prescription) {
                final thirtyDaysAgo =
                    DateTime.now().subtract(const Duration(days: 30));
                return prescription.createdAt.isAfter(thirtyDaysAgo);
              }).length;

        return QuickActionButton(
          title: 'Order\nMedicines',
          subtitle: '$activePrescriptions active prescriptions',
          icon: Icons.shopping_cart_rounded,
          onTap: () => _showOrderMedicinesList(context),
          isLoading: isLoading,
        );
      },
    );
  }
}
