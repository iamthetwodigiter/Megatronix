import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/event_registration/presentation/notifier/event_registration_notifier.dart';
import 'package:megatronix/features/event_registration/presentation/widgets/event_by_gid_card.dart';
import 'package:megatronix/features/event_registration/providers/events_registration_provider.dart';
import 'package:megatronix/theme/app_theme.dart';

class EventByGidPage extends ConsumerStatefulWidget {
  final String gid;
  const EventByGidPage({
    super.key,
    required this.gid,
  });

  @override
  ConsumerState<EventByGidPage> createState() => _EventByGidPageState();
}

class _EventByGidPageState extends ConsumerState<EventByGidPage> {
  List<Color> colorizeColors = [
    AppTheme.whiteBackground,
    AppTheme.primaryBlueAccentColor,
    AppTheme.darkBackground,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(eventsRegistrationNotifierProvider.notifier)
          .getTeamsByGID(widget.gid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final eventByGidState = ref.watch(eventsRegistrationNotifierProvider);

    ref.listen<EventRegistrationState>(eventsRegistrationNotifierProvider,
        (previous, current) {
      if (eventByGidState.isLoading) return;
      // if (current.error != null && context.mounted) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     AppErrorHandler.handleError(
      //       context,
      //       'Error',
      //       current.error!.replaceAll("Exception: ", ""),
      //     );
      //   });
      //   return;
      // }

      if (current.eventByGID == null && context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppErrorHandler.handleError(
            context,
            'Error',
            current.error!.replaceAll("Exception: ", ""),
          );
        });
        return;
      }

      // if (current.eventByGID != null && current.eventByGID!.isEmpty) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     AppErrorHandler.handleError(
      //       context,
      //       'Warning',
      //       'You have not registered in any events yet',
      //       type: ToastificationType.warning,
      //     );
      //   });
      //   return;
      // }
    });

    if (eventByGidState.isLoading) {
      return CustomScaffold(
        title: 'Registered Events',
        child: Center(
          child: LoadingWidget(),
        ),
      );
    }

    if (eventByGidState.eventByGID != null &&
        eventByGidState.eventByGID!.isEmpty) {
      return CustomScaffold(
        title: 'Registered Events',
        child: Container(
          height: size.height,
          width: size.width,
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              'You have not registered in any events yet using this GID',
              style: TextStyle(
                fontSize: 25,
                color: AppTheme.whiteBackground,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    if (eventByGidState.eventByGID != null &&
        eventByGidState.eventByGID!.isNotEmpty) {
      return CustomScaffold(
        title: 'Registered Events',
        child: Container(
          height: size.height,
          width: size.width,
          padding: EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemCount: eventByGidState.eventByGID?.length ?? 0,
            itemBuilder: (context, index) {
              final eventByGidEntity =
                  eventByGidState.eventByGID!.elementAt(index);
              return EventByGidCard(
                index: index,
                eventByGidEntity: eventByGidEntity,
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Text(
          'Failed to load registered events list',
          style: TextStyle(
            fontSize: 25,
            color: AppTheme.primaryBlueAccentColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
