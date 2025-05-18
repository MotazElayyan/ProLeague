import 'package:flutter/material.dart';

import 'package:grad_project/screens/signinOptions/changePassword.dart';
import 'package:grad_project/core/firestoreServices/usersData.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _imageUrl;
  String? _username;

  @override
  void initState() {
    super.initState();
    _fetchUserProfileData();
  }

  Future<void> _fetchUserProfileData() async {
    final profileData = await UserProfileService.loadUserProfile();

    setState(() {
      _imageUrl = profileData['imageUrl'];
      _username = profileData['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage:
                      _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                  child:
                      _imageUrl == null
                          ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                          : null,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _username ?? 'Loading...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              _buildSectionTitle('   General Settings'),
              const SizedBox(height: 10),
              _buildSettingTile(
                icon: Icons.key,
                label: 'Change Password',
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (ctx) => ChangePassword()));
                },
              ),
              const SizedBox(height: 30),
              _buildSectionTitle('   Information'),
              const SizedBox(height: 10),
              _buildSettingTile(
                icon: Icons.phone_iphone,
                label: 'About App',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.privacy_tip_rounded,
                label: 'Privacy Policy',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.share,
                label: 'Share This App',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      height: 40,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}
