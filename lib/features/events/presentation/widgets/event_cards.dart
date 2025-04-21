import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megatronix/features/events/domain/entities/events_entity.dart';
import 'package:megatronix/features/events/presentation/pages/event_details_page.dart';
import 'package:megatronix/features/events/presentation/pages/web/event_details_web_page.dart';
import 'package:megatronix/theme/app_theme.dart';

class EventCards extends StatefulWidget {
  final EventsEntity event;
  final int index;
  final bool isWebPage;
  const EventCards({
    super.key,
    required this.event,
    required this.index,
    this.isWebPage = false,
  });

  @override
  State<EventCards> createState() => _EventCardsState();
}

class _EventCardsState extends State<EventCards> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight = widget.isWebPage 
            ? constraints.maxWidth > 800 ? 300.0 : 250.0
            : 175.0;
            
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return widget.isWebPage
                    ? EventDetailsWebPage(event: widget.event)
                    : EventDetailsPage(event: widget.event);
              }));
            },
            child: FadeIn(
              delay: Duration(milliseconds: 100 * widget.index),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: cardHeight,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: AppTheme.darkBackground,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: AppTheme.primaryBlueAccentColor,
                        width: widget.isWebPage ? 1.0 : 0.65,
                      ),
                      boxShadow: widget.isWebPage ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ] : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CachedNetworkImage(
                        imageUrl: widget.event.eventPictureUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: cardHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withAlpha(25),
                          Colors.black.withAlpha(175),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 35,
                    left: 15,
                    right: 15,
                    child: Text(
                      widget.event.name,
                      style: TextStyle(
                        fontSize: constraints.maxWidth > 800 ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
