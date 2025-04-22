import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/features/events/domain/entities/combo_entity.dart';
import 'package:megatronix/features/events/presentation/pages/event_details_page.dart';
import 'package:megatronix/features/events/presentation/widgets/combo_registration_button.dart';
import 'package:megatronix/theme/app_theme.dart';

class ComboDetailsPage extends StatefulWidget {
  final ComboEntity combo;
  const ComboDetailsPage({
    super.key,
    required this.combo,
  });

  @override
  State<ComboDetailsPage> createState() => _ComboDetailsPageState();
}

class _ComboDetailsPageState extends State<ComboDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return CustomScaffold(
      title: widget.combo.name,
      secondaryImage: 'assets/images/background.png',
      customLottie: true,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                kToolbarHeight -
                (MediaQuery.of(context).padding.vertical),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CachedNetworkImage(
                        imageUrl: widget.combo.image,
                        height: 300,
                        width: size.width / 1.2,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return Center(
                            child: Icon(
                              Icons.error,
                              color: AppTheme.primaryBlueAccentColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.combo.description,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Events included in this combo',
                    style: TextStyle(
                      color: AppTheme.inactiveColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '[Click the events to view details]',
                    style: TextStyle(
                      color: AppTheme.inactiveColor,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 25 * (widget.combo.events.length).toDouble(),
                    child: ListView.builder(
                      itemCount: widget.combo.events.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EventDetailsPage(
                                  event: widget.combo.events[index],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            '${index + 1}. ${widget.combo.events[index].name}',
                            style: TextStyle(
                              color: AppTheme.primaryBlueAccentColor,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              decorationColor: AppTheme.primaryBlueAccentColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ComboRegistrationButton(
                  registrationOpen: widget.combo.registrationOpen,
                  combo: widget.combo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
