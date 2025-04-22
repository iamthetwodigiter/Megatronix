import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:megatronix/common/pages/splash_screen.dart';
import 'package:megatronix/common/pages/web/landing_web_page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:megatronix/config/config.dart';
import 'package:megatronix/theme/app_theme.dart';

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

  runApp(ProviderScope(child: Megatronix()));
}

class Megatronix extends ConsumerStatefulWidget {
  const Megatronix({super.key});

  @override
  ConsumerState<Megatronix> createState() => _ParidhiState();
}

class _ParidhiState extends ConsumerState<Megatronix> {
  @override
  void initState() {
    super.initState();

    Box preferences = Hive.box('preferences');

    if (!preferences.keys.contains('enableAnimation')) {
      preferences.put('enableAnimation', true);
    }
    if (!preferences.keys.contains('firstTime')) {
      preferences.put('firstTime', true);
    } else if(preferences.get('firstTime') == true) {
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
          color: Color.fromARGB(171, 19, 21, 41),
          titleTextStyle: TextStyle(
            color: AppTheme.whiteBackground,
            fontSize: 25,
            fontFamily: 'DaggerSquare',
          ),
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppTheme.scaffoldBackgroundColor,
        fontFamily: 'Couture',
        fontFamilyFallback: ['Poppins'],
      ),
      home: kIsWeb ? LandingWebPage() : SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
