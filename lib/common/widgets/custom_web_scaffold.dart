import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:megatronix/common/pages/web/landing_web_page.dart';
import 'package:megatronix/features/contact/presentation/pages/web/contact_web_page.dart';
import 'package:megatronix/features/events/presentation/pages/web/events_home_web_page.dart';
import 'package:megatronix/features/gallery/presentation/pages/web/gallery_web_page.dart';
import 'package:megatronix/features/home/presentation/pages/web/home_web_page.dart';
import 'package:megatronix/features/team/presentation/pages/web/team_home_web_page.dart';
import 'package:megatronix/theme/app_theme.dart';

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<({Widget page, String title, IconData icon})> pages;
  final bool isMainPage;

  const ResponsiveAppBar({
    super.key,
    required this.pages,
    this.isMainPage = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(75);

  @override
  Widget build(BuildContext context) {
    if (isMainPage) {
      return PreferredSize(preferredSize: preferredSize, child: SizedBox());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWideScreen = constraints.maxWidth > 800;

        return AppBar(
          backgroundColor: AppTheme.bottomNavBarColor,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Image.asset(
              'assets/images/megatronix.png',
              height: 60,
            ),
          ),
          titleTextStyle: TextStyle(fontSize: 15, fontFamily: 'DaggerSquare'),
          toolbarHeight: 75,
          title:
              isWideScreen ? _buildWideScreenMenu(context) : const SizedBox(),
          actions: !isWideScreen
              ? [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu, color: AppTheme.whiteBackground),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
                ]
              : null,
        );
      },
    );
  }

  Widget _buildWideScreenMenu(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...List.generate(
          pages.length,
          (index) => MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => LandingWebPage(),
                    ),
                    (route) => false,
                  );
                  return;
                }
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => pages[index].page,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      pages[index].icon,
                      color: AppTheme.whiteBackground,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pages[index].title,
                      style: TextStyle(
                        color: AppTheme.whiteBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomWebScaffold extends StatefulWidget {
  final String title;
  final Widget child;
  final bool isMainPage;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final String? customLottie;
  final double customOpacity;
  final bool isDisabled;
  const CustomWebScaffold({
    super.key,
    required this.title,
    required this.child,
    this.isMainPage = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.customLottie,
    this.customOpacity = 1,
    this.isDisabled = false,
  });

  @override
  State<CustomWebScaffold> createState() => _CustomWebScaffoldState();
}

class _CustomWebScaffoldState extends State<CustomWebScaffold> {
  final List<({Widget page, String title, IconData icon})> _pages = [
    (page: HomeWebPage(isMainPage: false), title: 'Home', icon: Icons.home),
    (
      page: EventsHomeWebPage(isMainPage: false),
      title: 'Events',
      icon: Icons.event
    ),
    (
      page: TeamHomeWebPage(isMainPage: false),
      title: 'Team',
      icon: Icons.group
    ),
    (
      page: GalleryWebPage(isMainPage: false),
      title: 'Gallery',
      icon: Icons.image
    ),
    (
      page: ContactWebPage(isMainPage: false),
      title: 'Contact',
      icon: Icons.contact_page
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool isWideScreen = size.width > 750;

    return Scaffold(
      appBar: widget.isMainPage
          ? null
          : PreferredSize(
              preferredSize: Size.fromHeight(75),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return AppBar(
                    backgroundColor: AppTheme.bottomNavBarColor,
                    elevation: 0,
                    leading: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Image.asset(
                        'assets/images/megatronix.png',
                        height: 60,
                      ),
                    ),
                    titleTextStyle:
                        TextStyle(fontSize: 15, fontFamily: 'DaggerSquare'),
                    toolbarHeight: 75,
                    title: isWideScreen ? _buildWideScreenMenu(context) : null,
                    actions: !isWideScreen
                        ? [
                            Builder(
                              builder: (context) => IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: AppTheme.whiteBackground,
                                ),
                                onPressed: () =>
                                    Scaffold.of(context).openEndDrawer(),
                              ),
                            ),
                          ]
                        : null,
                  );
                },
              ),
            ),
      endDrawer: !isWideScreen
          ? Drawer(
              child: Container(
                color: AppTheme.bottomNavBarColor,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: AppTheme.bottomNavBarColor,
                      ),
                      child: Image.asset(
                        'assets/images/megatronix.png',
                        height: 60,
                      ),
                    ),
                    ..._buildDrawerItems(context),
                  ],
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          Opacity(
            opacity: widget.customOpacity,
            child: RotatedBox(
              quarterTurns: -1,
              child: LottieBuilder.asset(
                widget.customLottie ?? 'assets/animations/background.json',
                height: size.width,
                width: size.height,
                frameRate: FrameRate(60),
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

  Widget _buildWideScreenMenu(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(
        _pages.length,
        (index) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (index == 0) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LandingWebPage()),
                  (route) => false,
                );
                return;
              }
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => _pages[index].page),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: widget.title == _pages[index].title
                        ? AppTheme.primaryBlueAccentColor
                        : AppTheme.transparentColor,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _pages[index].icon,
                    color: widget.title == _pages[index].title
                        ? AppTheme.primaryBlueAccentColor
                        : AppTheme.whiteBackground,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _pages[index].title,
                    style: TextStyle(
                      color: widget.title == _pages[index].title
                          ? AppTheme.primaryBlueAccentColor
                          : AppTheme.whiteBackground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    return List.generate(
      _pages.length,
      (index) => ListTile(
        leading: Icon(
          _pages[index].icon,
          color: widget.title == _pages[index].title
              ? AppTheme.primaryBlueAccentColor
              : AppTheme.whiteBackground,
        ),
        title: Text(
          _pages[index].title,
          style: TextStyle(
            color: widget.title == _pages[index].title
                ? AppTheme.primaryBlueAccentColor
                : AppTheme.whiteBackground,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (index == 0) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LandingWebPage()),
              (route) => false,
            );
            return;
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => _pages[index].page),
          );
        },
      ),
    );
  }
}
