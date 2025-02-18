import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_care/ui/screens/emergency_contacts_screen.dart';
import '../../core/providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/document_vault_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Header
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              backgroundImage: authProvider.userPhotoUrl != null
                                  ? NetworkImage(authProvider.userPhotoUrl!)
                                  : null,
                              child: authProvider.userPhotoUrl == null
                                  ? Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              authProvider.userName,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              authProvider.userEmail,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Show edit profile dialog
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Quick Actions
                  _buildSection(
                    context,
                    'Quick Actions',
                    [
                      _buildActionTile(
                        context,
                        'Emergency Contacts',
                        Icons.emergency,
                        Colors.red,
                        () {
                          // Navigate to emergency contacts
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EmergencyContactsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionTile(
                        context,
                        'Medical Information',
                        Icons.medical_information,
                        Colors.blue,
                        () {
                          // Navigate to medical info
                        },
                      ),
                      _buildActionTile(
                        context,
                        'Documents',
                        Icons.folder,
                        Colors.orange,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DocumentVaultScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Settings
                  _buildSection(
                    context,
                    'Settings',
                    [
                      _buildSettingTile(
                        context,
                        'Notifications',
                        Icons.notifications_outlined,
                        () {
                          // Navigate to notifications settings
                        },
                      ),
                      _buildSettingTile(
                        context,
                        'Privacy',
                        Icons.privacy_tip_outlined,
                        () {
                          // Navigate to privacy settings
                        },
                      ),
                      _buildSettingTile(
                        context,
                        'Help & Support',
                        Icons.help_outline,
                        () {
                          // Navigate to help & support
                        },
                      ),
                      _buildSettingTile(
                        context,
                        'About',
                        Icons.info_outline,
                        () {
                          // Navigate to about page
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sign Out Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await authProvider.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error signing out: $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                      backgroundColor: Colors.red.withOpacity(0.1),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
    );
  }
} 