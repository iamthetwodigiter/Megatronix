import 'package:flutter/material.dart';
import 'package:megatronix/features/profile/presentation/pages/user_profile_page.dart';

class CustomScaffold extends StatefulWidget {
  final String title;
  final Widget child;
  final bool isMainPage;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final String? secondaryImage;
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
    this.customOpacity = 1,
    this.isDisabled = false,
  });

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

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
          Opacity(
            opacity: widget.customOpacity,
            child: Image.asset(
              widget.secondaryImage ?? 'assets/images/background.png',
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
