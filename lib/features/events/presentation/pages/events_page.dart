import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/features/events/domain/entities/domain_poster_entity.dart';
import 'package:megatronix/features/events/presentation/widgets/domain_events_cards.dart';
import 'package:megatronix/features/events/providers/events_providers.dart';
import 'package:megatronix/features/main_registration/presentation/pages/main_registration_page.dart';
import 'package:megatronix/theme/app_theme.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
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

    if (state.isLoading) {
      return CustomScaffold(
        title: 'Domains',
        secondaryImage: 'assets/images/background/home.jpg',
        customLottie: true,
        child: Center(
          child: LoadingWidget(),
        ),
      );
    }
    return CustomScaffold(
      title: 'Domains',
      secondaryImage: 'assets/images/background/home.jpg',
      customLottie: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return MainRegistrationPage();
              },
            ),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 25,
            children: [
              SizedBox(),
              BounceInDown(
                delay: Duration(milliseconds: 100),
                child: DomainEventsCards(
                  domain: 'CODING',
                  posterUrl:
                      getPosterUrlForDomain(state.domainPosters, 'CODING'),
                ),
              ),
              BounceInDown(
                delay: Duration(milliseconds: 200),
                child: DomainEventsCards(
                  domain: 'ROBOTICS',
                  posterUrl:
                      getPosterUrlForDomain(state.domainPosters, 'ROBOTICS'),
                ),
              ),
              BounceInDown(
                delay: Duration(milliseconds: 300),
                child: DomainEventsCards(
                  domain: 'CIVIL',
                  posterUrl:
                      getPosterUrlForDomain(state.domainPosters, 'CIVIL'),
                ),
              ),
              BounceInDown(
                delay: Duration(milliseconds: 400),
                child: DomainEventsCards(
                  domain: 'ELECTRICAL',
                  posterUrl:
                      getPosterUrlForDomain(state.domainPosters, 'ELECTRICAL'),
                ),
              ),
              BounceInDown(
                delay: Duration(milliseconds: 500),
                child: DomainEventsCards(
                  domain: 'GENERAL',
                  posterUrl:
                      getPosterUrlForDomain(state.domainPosters, 'GENERAL'),
                ),
              ),
              BounceInDown(
                delay: Duration(milliseconds: 600),
                child: DomainEventsCards(
                  domain: 'GAMING',
                  posterUrl:
                      getPosterUrlForDomain(state.domainPosters, 'GAMING'),
                ),
              ),
              BounceInDown(
                delay: Duration(milliseconds: 700),
                child: DomainEventsCards(
                  domain: 'EXCLUSIVE',
                  posterUrl:
                      getPosterUrlForDomain(state.domainPosters, 'EXCLUSIVE'),
                ),
              ),
              SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }
}
