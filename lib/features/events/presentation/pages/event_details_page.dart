import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/custom_image.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/custom_richtext.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/events/domain/entities/events_entity.dart';
import 'package:megatronix/features/events/presentation/widgets/call_button.dart';
import 'package:megatronix/features/events/presentation/widgets/registration_button.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatefulWidget {
  final EventsEntity event;
  const EventDetailsPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  void _openRulebook() async {
    try {
      await launchUrl(
        Uri.parse(widget.event.ruleBook),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      AppErrorHandler.handleError(
        context,
        'Error',
        'Error accessing rulebook\nTry again later',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return CustomScaffold(
      title: widget.event.name,
           secondaryImage: 'assets/images/background.png',

      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CustomImage(
                    image: widget.event.eventPictureUrl,
                    height: 300,
                    width: size.width,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.event.description,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              CustomRichtext(
                title: 'Event Date',
                subtitle: widget.event.eventDate,
              ),
              CustomRichtext(
                title: 'Event Type',
                subtitle: widget.event.eventType,
              ),
              CustomRichtext(
                title: 'Venue',
                subtitle: widget.event.venue,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    'Coordianator Details:',
                    style: TextStyle(fontSize: 18),
                  ),
                  CallButton(
                    name: widget.event.coordinatorDetails[0].split("- ").first,
                    number: widget.event.coordinatorDetails[0].split("- ").last,
                  ),
                  CallButton(
                    name: widget.event.coordinatorDetails[1].split("- ").first,
                    number: widget.event.coordinatorDetails[1].split("- ").last,
                  ),
                ],
              ),
              CustomRichtext(
                title: 'Min Players',
                subtitle: widget.event.minPlayers.toString(),
              ),
              CustomRichtext(
                title: 'Max Players',
                subtitle: widget.event.maxPlayers.toString(),
              ),
              CustomRichtext(
                title: 'Registration Fees',
                subtitle: '₹${widget.event.registrationFee}',
              ),
              CustomRichtext(
                title: 'Prize Pool',
                subtitle: '₹${widget.event.prizePool}',
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.center,
                child: CustomButton(
                  onPressed: _openRulebook,
                  buttonText: 'Rulebook',
                ),
              ),
              SizedBox(height: 15),
              RegistrationButton(
                registrationOpen: widget.event.registrationOpen,
                eventID: widget.event.id,
                minPlayers: widget.event.minPlayers.toInt(),
                maxPlayers: widget.event.maxPlayers.toInt(),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
