import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_web_scaffold.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/core/utils/responsive_utils.dart';
import 'package:megatronix/features/events/domain/entities/domain_poster_entity.dart';
import 'package:megatronix/features/events/presentation/widgets/domain_events_cards.dart';
import 'package:megatronix/features/events/providers/events_providers.dart';
import 'package:megatronix/features/main_registration/presentation/pages/web/main_registration_web_page.dart';
import 'package:megatronix/theme/app_theme.dart';

class EventsWebPage extends ConsumerStatefulWidget {
  const EventsWebPage({super.key});

  @override
  ConsumerState<EventsWebPage> createState() => _EventsWebPageState();
}

class _EventsWebPageState extends ConsumerState<EventsWebPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventsNotifierProvider.notifier).getAllDomainPosters();
    });
  }

  String getPosterUrlForDomain(
      List<DomainPosterEntity>? posters, String domain) {
    if (posters == null) return '';
    try {
      return posters
          .firstWhere((element) => element.domainName == domain)
          .posterUrl;
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventsNotifierProvider);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = ResponsiveBreakpoints.isMobile(size.width);
    final isTablet = ResponsiveBreakpoints.isTablet(size.width);

    if (state.isLoading) {
      return CustomWebScaffold(
        title: 'Events',
        child: Center(child: LoadingWidget()),
      );
    }

    return CustomWebScaffold(
      title: 'Events',
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MainRegistrationWebPage()),
          );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlueAccentColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            'Main Registration',
            style: TextStyle(
              color: AppTheme.whiteBackground,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: isSmallScreen
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                      _buildEventCards(state, size, isSmallScreen, isTablet),
                )
              : Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children:
                      _buildEventCards(state, size, isSmallScreen, isTablet),
                ),
        ),
      ),
    );
  }

  List<Widget> _buildEventCards(
      dynamic state, Size size, bool isSmallScreen, bool isTablet) {
    final cardWidth = isSmallScreen
        ? size.width * 0.9
        : (isTablet ? size.width * 0.45 : size.width * 0.3);

    final domains = [
      'CODING',
      'ROBOTICS',
      'CIVIL',
      'ELECTRICAL',
      'GENERAL',
      'GAMING',
    ];

    return domains.map((domain) {
      Widget card = DomainEventsCards(
        domain: domain,
        posterUrl: getPosterUrlForDomain(state.domainPosters, domain),
        isWebPage: true,
        width: cardWidth,
      );

      return isSmallScreen
          ? Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: SizedBox(width: cardWidth, child: card),
            )
          : SizedBox(width: cardWidth, child: card);
    }).toList();
  }
}
