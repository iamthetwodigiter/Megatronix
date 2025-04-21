import 'package:flutter/material.dart';
import 'package:megatronix/features/contact/presentation/pages/web/contact_web_page.dart';
import 'package:megatronix/features/events/presentation/pages/web/events_home_web_page.dart';
import 'package:megatronix/features/gallery/presentation/pages/web/gallery_web_page.dart';
import 'package:megatronix/features/home/presentation/pages/web/home_web_page.dart';
import 'package:megatronix/features/profile/presentation/pages/web/user_profile_web_page.dart';
import 'package:megatronix/features/team/presentation/pages/web/team_home_web_page.dart';
import 'package:megatronix/theme/app_theme.dart';

class LandingWebPage extends StatefulWidget {
  const LandingWebPage({super.key});

  @override
  State<LandingWebPage> createState() => _LandingWebPageState();
}

class _LandingWebPageState extends State<LandingWebPage> {
  int _currentIndex = 0;

  final List<({Widget page, String title, IconData icon})> _pages = [
    (page: const HomeWebPage(), title: 'Home', icon: Icons.home),
    (page: const EventsHomeWebPage(), title: 'Events', icon: Icons.event),
    (page: const TeamHomeWebPage(), title: 'Team', icon: Icons.group),
    (page: const GalleryWebPage(), title: 'Gallery', icon: Icons.image),
    (page: const ContactWebPage(), title: 'Contact', icon: Icons.contact_page),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool isWideScreen = size.width > 750;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AppBar(
              backgroundColor: AppTheme.bottomNavBarColor,
              elevation: 0,
              titleTextStyle:
                  TextStyle(fontSize: 15, fontFamily: 'DaggerSquare'),
              toolbarHeight: 75,
              title: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return UserProfileWebPage();
                        }));
                      },
                      child: Image.asset('assets/images/megatronix.png',
                          height: 60)),
                  if (isWideScreen) ...[
                    const Spacer(),
                    ..._buildNavigationItems(),
                  ],
                ],
              ),
              actions: isWideScreen
                  ? null
                  : [
                      Builder(
                        builder: (context) => IconButton(
                          icon:
                              Icon(Icons.menu, color: AppTheme.whiteBackground),
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
                        ),
                      ),
                    ],
            );
          },
        ),
      ),
      endDrawer: isWideScreen
          ? null
          : Drawer(
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
                    ..._buildDrawerItems(),
                  ],
                ),
              ),
            ),
      body: Stack(
        children: List.generate(
          _pages.length,
          (index) => Offstage(
            offstage: _currentIndex != index,
            child: _pages[index].page,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavigationItems() {
    return List.generate(
      _pages.length,
      (index) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => setState(() => _currentIndex = index),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _currentIndex == index
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
                  color: _currentIndex == index
                      ? AppTheme.primaryBlueAccentColor
                      : AppTheme.whiteBackground,
                ),
                const SizedBox(width: 8),
                Text(
                  _pages[index].title,
                  style: TextStyle(
                    color: _currentIndex == index
                        ? AppTheme.primaryBlueAccentColor
                        : AppTheme.whiteBackground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDrawerItems() {
    return List.generate(
      _pages.length,
      (index) => ListTile(
        leading: Icon(
          _pages[index].icon,
          color: _currentIndex == index
              ? AppTheme.primaryBlueAccentColor
              : AppTheme.whiteBackground,
        ),
        title: Text(
          _pages[index].title,
          style: TextStyle(
            color: _currentIndex == index
                ? AppTheme.primaryBlueAccentColor
                : AppTheme.whiteBackground,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
