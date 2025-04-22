import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/features/events/presentation/widgets/combo_cards.dart';
import 'package:megatronix/features/events/presentation/widgets/event_cards.dart';
import 'package:megatronix/features/events/providers/events_providers.dart';

class DomainEventsPage extends ConsumerStatefulWidget {
  final String title;
  const DomainEventsPage({
    super.key,
    required this.title,
  });

  @override
  ConsumerState<DomainEventsPage> createState() => _DomainEventsPageState();
}

class _DomainEventsPageState extends ConsumerState<DomainEventsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(eventsNotifierProvider.notifier)
          .getAllEventsByDomain(widget.title.toUpperCase());
      ref
          .read(eventsNotifierProvider.notifier)
          .getAllCombosByDomain(widget.title.toUpperCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventsNotifierProvider);

    if (eventState.isLoading) {
      return CustomScaffold(
        title: widget.title,
        secondaryImage: 'assets/images/background/home.jpg',
        customLottie: true,
        child: Center(
          child: const LoadingWidget(),
        ),
      );
    }

    // if (eventState.error != null && context.mounted) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     AppErrorHandler.handleError(
    //       context,
    //       'Error',
    //       "Failed to fetch ${widget.title} events",
    //     );
    //   });
    // }

    if (eventState.eventsList != null &&
        eventState.eventsList!.isNotEmpty &&
        context.mounted) {
      return CustomScaffold(
        title: widget.title,
        secondaryImage: 'assets/images/background/home.jpg',
        customLottie: true,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: eventState.eventsList!.length +
                      (eventState.combosList?.isNotEmpty == true ? 1 : 0) +
                      (eventState.combosList?.length ?? 0),
                  itemBuilder: (context, index) {
                    if (index == eventState.eventsList!.length) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Combo Events',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      );
                    } else if (index > eventState.eventsList!.length) {
                      // Combo events
                      final comboIndex =
                          index - eventState.eventsList!.length - 1;
                      final combo = eventState.combosList![comboIndex];
                      return ComboCards(combo: combo, index: comboIndex);
                    } else {
                      // Normal events
                      final event = eventState.eventsList!.elementAt(index);
                      return EventCards(
                        event: event,
                        index: index,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    // if (eventState.eventsList == null || eventState.eventsList!.isEmpty) {
    return CustomScaffold(
      title: widget.title,
      secondaryImage: 'assets/images/background/home.jpg',
      customLottie: true,
      child: Center(
        child: Text(
          'NO ONGOING EVENTS...',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
