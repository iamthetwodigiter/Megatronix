import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:megatronix/common/pages/splash_screen.dart';
import 'package:megatronix/config/config.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive Flutter
  await Hive.initFlutter();
  if (!Hive.isBoxOpen('preferences')) {
    await Hive.openBox('preferences');
  }

  // Initialize OneSignal
  OneSignal.initialize(Config.oneSignalAppID);
  OneSignal.Notifications.requestPermission(true);

  // Set the orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(ProviderScope(child: MegatronixAmongUs()));
}

class MegatronixAmongUs extends ConsumerStatefulWidget {
  const MegatronixAmongUs({super.key});

  @override
  ConsumerState<MegatronixAmongUs> createState() => _MegatronixAmongUsState();
}

class _MegatronixAmongUsState extends ConsumerState<MegatronixAmongUs> {
  @override
  void initState() {
    super.initState();

    Box preferences = Hive.box('preferences');

    if (!preferences.keys.contains('enableAnimation')) {
      preferences.put('enableAnimation', true);
    }
    if (!preferences.keys.contains('firstTime')) {
      preferences.put('firstTime', true);
    } else if (preferences.get('firstTime') == true) {
      preferences.put('firstTime', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Megatronix',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          toolbarHeight: 50,
          color: Color.fromARGB(171, 41, 19, 19),
          titleTextStyle: TextStyle(
            color: AppTheme.whiteBackground,
            fontSize: 25,
            fontFamily: 'FiraCode',
          ),
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppTheme.scaffoldBackgroundColor,
        fontFamily: 'FiraCode',
        fontFamilyFallback: ['Poppins'],
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
