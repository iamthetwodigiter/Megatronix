import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_web_scaffold.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/features/events/presentation/widgets/combo_cards.dart';
import 'package:megatronix/features/events/presentation/widgets/event_cards.dart';
import 'package:megatronix/features/events/providers/events_providers.dart';

class DomainEventsWebPage extends ConsumerStatefulWidget {
  final String title;
  const DomainEventsWebPage({
    super.key,
    required this.title,
  });

  @override
  ConsumerState<DomainEventsWebPage> createState() =>
      _DomainEventsWebPageState();
}

class _DomainEventsWebPageState extends ConsumerState<DomainEventsWebPage> {
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
      return CustomWebScaffold(
        title: widget.title,
        customLottie: 'assets/animations/stars.json',
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
      return CustomWebScaffold(
        title: widget.title,
        customLottie: 'assets/animations/stars.json',
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: [
                        ...eventState.eventsList!.map((event) => SizedBox(
                          width: constraints.maxWidth > 1200 
                              ? constraints.maxWidth * 0.3 
                              : constraints.maxWidth > 800 
                                  ? constraints.maxWidth * 0.45
                                  : constraints.maxWidth,
                          child: EventCards(
                            event: event,
                            index: eventState.eventsList!.indexOf(event),
                            isWebPage: true,
                          ),
                        )),
                        
                        if (eventState.combosList?.isNotEmpty == true) ...[
                          SizedBox(
                            width: constraints.maxWidth,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0),
                              child: Text(
                                'Combo Events',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: constraints.maxWidth > 800 ? 24 : 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          ...eventState.combosList!.map((combo) => SizedBox(
                            width: constraints.maxWidth > 1200 
                                ? constraints.maxWidth * 0.3 
                                : constraints.maxWidth > 800 
                                    ? constraints.maxWidth * 0.45
                                    : constraints.maxWidth,
                            child: ComboCards(
                              combo: combo,
                              index: eventState.combosList!.indexOf(combo),
                              isWebPage: true,
                            ),
                          )),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return CustomWebScaffold(
      title: widget.title,
      customLottie: 'assets/animations/stars.json',
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
