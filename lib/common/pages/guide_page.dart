import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/theme/app_theme.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Guide',
      isMainPage: true,
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            'How to register?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 3,
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Main Registration'),
                  subtitle: const Text(
                    'Navigate to Events > Paridhi > Main Registration to complete Paridhi 2025 registration to be able to participate in events.',
                    style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                  ),
                  leading: Text(
                    '1. ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: const Text('Event Registration'),
                  subtitle: const Text(
                    'Navigate to Events > Paridhi > Domain > Events > Event Registration to register for events.',
                    style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                  ),
                  leading: Text(
                    '2. ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: const Text('Combo Event Registration'),
                  subtitle: const Text(
                    'Navigate to Events > Paridhi > Domain > Combo Events > Combo Events Registration to register your team for combo events.',
                    style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                  ),
                  leading: Text(
                    '3. ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: AppTheme.dividerColor,
          ),
          const SizedBox(height: 8),
          const Text(
            'Is that all?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 2,
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Authentication'),
                  subtitle: const Text(
                    'You need to be logged in to complete main registration.',
                    style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                  ),
                  leading: Text(
                    '1. ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: const Text('Profile'),
                  subtitle: const Text(
                    'All your data will be saved in your profile, like GID, Name, College, etc. To access your profile, click on the megatronix logo on the top right.',
                    style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                  ),
                  leading: Text(
                    '2. ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                
              ],
            ),
          ),
          SizedBox(height: 75)
        ],
      ),
    );
  }
}
