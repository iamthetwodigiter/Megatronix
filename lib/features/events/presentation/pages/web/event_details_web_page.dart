import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/custom_image.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/custom_web_scaffold.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/core/utils/responsive_utils.dart';
import 'package:megatronix/features/events/domain/entities/events_entity.dart';
import 'package:megatronix/features/events/presentation/widgets/call_button.dart';
import 'package:megatronix/features/events/presentation/widgets/registration_button.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsWebPage extends StatefulWidget {
  final EventsEntity event;
  const EventDetailsWebPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsWebPage> createState() => _EventDetailsWebPageState();
}

class _EventDetailsWebPageState extends State<EventDetailsWebPage> {
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = ResponsiveBreakpoints.isMobile(size.width);
    final isTablet = ResponsiveBreakpoints.isTablet(size.width);

    return CustomWebScaffold(
      title: widget.event.name,
      customLottie: 'assets/animations/stars.json',
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 24,
            vertical: 20,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 1200,
              minHeight: size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.vertical,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(isSmallScreen ? 20 : 25),
                    child: CustomImage(
                      image: widget.event.eventPictureUrl,
                      height: isSmallScreen ? 200 : 300,
                      width: isSmallScreen
                          ? size.width * 0.9
                          : (isTablet ? size.width * 0.8 : size.width * 0.6),
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 15 : 20),

                // Description
                Text(
                  widget.event.description,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: isSmallScreen ? 20 : 25),

                // Event Details Cards
                Wrap(
                  spacing: isSmallScreen ? 10 : 20,
                  runSpacing: isSmallScreen ? 10 : 20,
                  children: [
                    _buildDetailCard(
                      'Event Date',
                      widget.event.eventDate,
                      size,
                      isSmallScreen,
                    ),
                    _buildDetailCard(
                      'Event Type',
                      widget.event.eventType,
                      size,
                      isSmallScreen,
                    ),
                    _buildDetailCard(
                      'Venue',
                      widget.event.venue,
                      size,
                      isSmallScreen,
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 20 : 25),

                // Coordinator and Prize Details
                isSmallScreen
                    ? Column(
                        children: [
                          _buildCoordinatorSection(isSmallScreen),
                          SizedBox(height: 15),
                          _buildPrizeSection(isSmallScreen),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: _buildCoordinatorSection(isSmallScreen)),
                          SizedBox(width: 20),
                          Expanded(child: _buildPrizeSection(isSmallScreen)),
                        ],
                      ),
                SizedBox(height: isSmallScreen ? 20 : 25),

                // Player Details Cards
                Wrap(
                  spacing: isSmallScreen ? 10 : 20,
                  runSpacing: isSmallScreen ? 10 : 20,
                  children: [
                    _buildDetailCard(
                      'Min Players',
                      widget.event.minPlayers.toString(),
                      size,
                      isSmallScreen,
                    ),
                    _buildDetailCard(
                      'Max Players',
                      widget.event.maxPlayers.toString(),
                      size,
                      isSmallScreen,
                    ),
                    _buildDetailCard(
                      'Registration Fees',
                      '₹${widget.event.registrationFee}',
                      size,
                      isSmallScreen,
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 25 : 30),

                // Buttons
                Center(
                  child: Column(
                    children: [
                      CustomButton(
                        onPressed: _openRulebook,
                        buttonText: 'Rulebook',
                        isWebPage: true,
                      ),
                      SizedBox(height: isSmallScreen ? 15 : 20),
                      RegistrationButton(
                        registrationOpen: widget.event.registrationOpen,
                        eventID: widget.event.id,
                        minPlayers: widget.event.minPlayers.toInt(),
                        maxPlayers: widget.event.maxPlayers.toInt(),
                        isWebPage: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(
      String title, String value, Size size, bool isSmallScreen) {
    return Container(
      width: isSmallScreen
          ? size.width * 0.9
          : (size.width * 0.25).clamp(0.0, 350.0),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 15),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
        border: Border.all(
          color: Colors.white24,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: isSmallScreen ? 4 : 5),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinatorSection(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
        border: Border.all(
          color: Colors.white24,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coordinator Details:',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 15),
          Wrap(
            spacing: isSmallScreen ? 15 : 20,
            runSpacing: isSmallScreen ? 12 : 15,
            alignment: WrapAlignment.start,
            children: widget.event.coordinatorDetails.map((coordinator) {
              final parts = coordinator.split("- ");
              return CallButton(
                name: parts.first,
                number: parts.last,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPrizeSection(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
        border: Border.all(
          color: Colors.white24,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prize Pool Details:',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 15),
          Text(
            '₹${widget.event.prizePool}',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
