import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:megatronix/common/pages/dev_easter_egg.dart';
import 'package:megatronix/common/pages/settings_page.dart';
import 'package:megatronix/common/widgets/blinking_stars.dart';
import 'package:megatronix/features/profile/presentation/pages/user_profile_page.dart';

class CustomScaffold extends StatefulWidget {
  final String title;
  final Widget child;
  final bool isMainPage;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final String? secondaryImage;
  final bool? customLottie;
  final double customOpacity;
  final bool isDisabled;
  const CustomScaffold({
    super.key,
    required this.title,
    required this.child,
    this.isMainPage = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.secondaryImage,
    this.customLottie = false,
    this.customOpacity = 0.8,
    this.isDisabled = false,
  });

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final Box _preferences = Hive.box('preferences');
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool enableAnimation =
        _preferences.get('enableAnimation', defaultValue: true) ?? true;
    return Scaffold(
      appBar: AppBar(
        excludeHeaderSemantics: true,
        toolbarHeight: widget.isMainPage ? 75 : 50,
        title: Padding(
          padding:
              widget.isMainPage ? EdgeInsets.only(top: 30) : EdgeInsets.zero,
          child: Text(
            widget.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        leading: widget.isMainPage
            ? Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onLongPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DevEasterEgg(),
                      ),
                    );
                  },
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.settings,
                  ),
                ),
              )
            : null,
        actions: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: IconButton(
                onPressed: () {
                  if (!widget.isDisabled) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserProfilePage(),
                      ),
                    );
                  }
                },
                icon: Image.asset(
                  'assets/images/megatronix.png',
                  height: 45,
                  width: 45,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          enableAnimation
              ? (widget.customLottie != null && widget.customLottie == true)
                  ? StarryBackground()
                  : Opacity(
                      opacity: widget.customOpacity,
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: LottieBuilder.asset(
                          'assets/animations/background.json',
                          height: size.width,
                          width: size.height,
                          frameRate: FrameRate(60),
                          fit: BoxFit.cover,
                        ),
                      ))
              : Opacity(
                  opacity: widget.customOpacity,
                  child: Image.asset(
                    widget.secondaryImage ??
                        'assets/images/background/secondary.jpg',
                    height: size.height,
                    width: size.width,
                    fit: BoxFit.cover,
                  ),
                ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: widget.child,
          ),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation ??
          FloatingActionButtonLocation.endFloat,
    );
  }
}
