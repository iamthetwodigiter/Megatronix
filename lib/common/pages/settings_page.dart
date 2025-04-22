import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Box _preferences = Hive.box('preferences');

  @override
  Widget build(BuildContext context) {
    final bool enableAnimation =
        _preferences.get('enableAnimation', defaultValue: true) ?? true;
    return CustomScaffold(
      title: 'Settings',
      child: SizedBox(
        height: 200,
        child: CupertinoListSection.insetGrouped(
          backgroundColor: AppTheme.transparentColor,
          footer: Text(
            'Enabling the animation will consume more battery and resources. For devices with limited resources, it is recommended to disable the animation.',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              color: AppTheme.whiteBackground,
            ),
          ),
          children: [
            CupertinoListTile(
              backgroundColor: AppTheme.darkBackground,
              title: Text(
                'Enable Animation',
                style: TextStyle(
                  fontSize: 18,
                  color: AppTheme.whiteBackground,
                ),
              ),
              trailing: CupertinoSwitch(
                value: enableAnimation,
                onChanged: (value) {
                  setState(() {
                    _preferences.put('enableAnimation', value);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
