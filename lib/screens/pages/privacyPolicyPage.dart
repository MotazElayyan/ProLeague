import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: PageView(
        children: [
          _buildPage1(context, colorScheme),
          _buildPage2(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildPage1(BuildContext context, ColorScheme colorScheme) {
    return _buildContent(
      context,
      colorScheme,
      children: [
        Text(
          'Privacy Policy',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Welcome to the Jordan Football Team App. Your privacy is important to us, and we are committed to protecting your personal data. This Privacy Policy explains how we collect, use, and share your information when you use our app.',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('1. Information We Collect'),
        Text(
          'When you use our app, we may collect the following types of information:',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        const SizedBox(height: 8),
        _buildBullet(
          '* Personal Information:',
          'Name, email address, and profile details if you create an account.',
        ),
        _buildBullet(
          '* Usage Data:',
          'How you interact with the app, such as viewed matches and favorite players.',
        ),
        _buildBullet(
          '* Device Information:',
          'Your device type, operating system, and app version.',
        ),
        _buildBullet(
          '* Location Data (Optional):',
          'If you allow, we may collect location data to provide personalized match recommendations.',
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('2. How We Use Your Information'),
        _buildBullet(
          '•',
          'Provide real-time match updates, player stats, and team news.',
        ),
        _buildBullet('•', 'Improve app performance and user experience.'),
        _buildBullet(
          '•',
          'Send notifications about upcoming matches and team events.',
        ),
        _buildBullet(
          '•',
          'Monitor app usage to enhance features and fix issues.',
        ),
      ],
    );
  }

  Widget _buildPage2(BuildContext context, ColorScheme colorScheme) {
    return _buildContent(
      context,
      colorScheme,
      children: [
        _buildSectionTitle('3. How We Share Your Information'),
        Text(
          'We do not sell your data. However, we may share it with:',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        const SizedBox(height: 8),
        _buildBullet(
          '* Service Providers:',
          'Third-party analytics and hosting services to improve the app.',
        ),
        _buildBullet(
          '* Legal Authorities:',
          'If required by law or to protect our rights.',
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('4. Your Privacy Choices'),
        _buildBullet(
          '* Account Settings:',
          'You can update or delete your account at any time.',
        ),
        _buildBullet(
          '* Notifications:',
          'Manage push notification preferences in app settings.',
        ),
        _buildBullet(
          '* Location Data:',
          'You can enable or disable location sharing through your device settings.',
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('5. Security Measures'),
        Text(
          'We take reasonable measures to protect your data, but no system is 100% secure. Please use strong passwords and avoid sharing account details.',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('6. Contact Us'),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.email, color: Theme.of(context).colorScheme.secondary),
            SizedBox(width: 8),
            Text(
              'ProLeague@gmail.com',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.phone, color: Theme.of(context).colorScheme.secondary),
            SizedBox(width: 8),
            Text(
              '0796743772',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    ColorScheme colorScheme, {
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildBullet(String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
