import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:megatronix/common/pages/guide_page.dart';
import 'package:megatronix/features/contact/presentation/pages/contact_page.dart';
import 'package:megatronix/features/events/presentation/pages/events_home_page.dart';
import 'package:megatronix/features/gallery/presentation/pages/gallery_page.dart';
import 'package:megatronix/features/home/presentation/pages/home_page.dart';
import 'package:megatronix/features/team/presentation/pages/team_home_page.dart';
import 'package:megatronix/theme/app_theme.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const EventsHomePage(),
    const TeamHomePage(),
    const GalleryPage(),
    const ContactPage(),
    const GuidePage()
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          alignment: Alignment.center,
          children: _pages,
        ),
      ),
      
      bottomNavigationBar: BottomBar(
        fit: StackFit.expand,
        icon: (width, height) => Center(
          child: Icon(
            Icons.arrow_upward_rounded,
            size: width,
          ),
        ),
        borderRadius: BorderRadius.circular(500),
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
        width: MediaQuery.of(context).size.width * 0.85,
        barColor: AppTheme.bottomNavBarColor,
        iconHeight: 35,
        iconWidth: 35,
        barDecoration: BoxDecoration(
          color: AppTheme.whiteBackground,
          borderRadius: BorderRadius.circular(500),
          border: Border.all(
            color: AppTheme.inactiveColor,
            width: 3,
          ),
        ),
        iconDecoration: BoxDecoration(
          color: AppTheme.whiteBackground,
          borderRadius: BorderRadius.circular(500),
        ),
        body: (context, controller) => TabBarView(
          controller: _tabController,
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          children: _pages,
        ),
        child: SafeArea(
          child: TabBar(
            onTap: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            controller: _tabController,
            indicatorColor: AppTheme.primaryBlueAccentColor,
            labelColor: AppTheme.primaryBlueAccentColor,
            unselectedLabelColor: AppTheme.whiteBackground,
            dividerColor: AppTheme.transparentColor,
            tabs: const [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.event)),
              Tab(icon: Icon(Icons.group)),
              Tab(icon: Icon(Icons.image)),
              Tab(icon: Icon(Icons.contact_page)),
              Tab(icon: Icon(Icons.help)),
            ],
          ),
        ),
      ),
    );
  }
}
