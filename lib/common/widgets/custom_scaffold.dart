import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:megatronix/common/pages/dev_easter_egg.dart';
import 'package:megatronix/common/pages/settings_page.dart';
import 'package:megatronix/common/widgets/blinking_stars.dart';
import 'package:megatronix/core/utils/util_functions.dart';
import 'package:megatronix/features/profile/presentation/pages/user_profile_page.dart';

class CustomScaffold extends StatefulWidget {
  final String title;
  final Widget child;
  final bool isMainPage;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final double customOpacity;
  final bool isDisabled;
  const CustomScaffold({
    super.key,
    this.title = '',
    required this.child,
    this.isMainPage = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
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
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);

    _images = UtilFunctions.getTextFieldImagesList(6);
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
              fontFamily: 'AmongUs',
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
                  _images[0],
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
              ? StarryBackground()
              : RotatedBox(
                  quarterTurns: 0,
                  child: Opacity(
                    opacity: widget.customOpacity,
                    child: Image.asset(
                      'assets/images/background.jpg',
                      height: size.width * 2,
                      width: size.height,
                      fit: BoxFit.cover,
                    ),
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
