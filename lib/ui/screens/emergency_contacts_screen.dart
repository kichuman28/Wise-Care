import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/emergency_contact_model.dart';
import '../../core/services/emergency_contact_service.dart';
import '../../core/providers/auth_provider.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final EmergencyContactService _contactService = EmergencyContactService();
  List<EmergencyContact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final userId = Provider.of<AuthProvider>(context, listen: false).uid;
    try {
      final contacts = await _contactService.getEmergencyContacts(userId);
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading contacts: $e')),
        );
      }
    }
  }

  Future<void> _showContactDialog([EmergencyContact? contact]) async {
    final nameController = TextEditingController(text: contact?.name);
    final phoneController = TextEditingController(text: contact?.phoneNumber);
    final relationController = TextEditingController(text: contact?.relation);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(contact == null ? 'Add Contact' : 'Edit Contact'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: relationController,
                decoration: const InputDecoration(labelText: 'Relation'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final userId = Provider.of<AuthProvider>(context, listen: false).uid;
              final newContact = EmergencyContact(
                id: contact?.id,
                name: nameController.text.trim(),
                phoneNumber: phoneController.text.trim(),
                relation: relationController.text.trim(),
                userId: userId,
              );

              try {
                if (contact == null) {
                  await _contactService.addEmergencyContact(newContact);
                } else {
                  await _contactService.updateEmergencyContact(newContact);
                }
                if (mounted) {
                  Navigator.pop(context);
                  _loadContacts();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving contact: $e')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteContact(EmergencyContact contact) async {
    try {
      await _contactService.deleteEmergencyContact(contact.userId, contact.id!);
      _loadContacts();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting contact: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return Card(
                  child: ListTile(
                    title: Text(contact.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(contact.phoneNumber),
                        Text(contact.relation),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showContactDialog(contact),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteContact(contact),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showContactDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
