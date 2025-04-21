import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/custom_web_scaffold.dart';
import 'package:megatronix/core/utils/responsive_utils.dart';
import 'package:megatronix/features/events/domain/entities/combo_entity.dart';
import 'package:megatronix/features/events/presentation/pages/event_details_page.dart';
import 'package:megatronix/features/events/presentation/widgets/combo_registration_button.dart';
import 'package:megatronix/theme/app_theme.dart';

class ComboDetailsWebPage extends StatefulWidget {
  final ComboEntity combo;
  const ComboDetailsWebPage({
    super.key,
    required this.combo,
  });

  @override
  State<ComboDetailsWebPage> createState() => _ComboDetailsWebPageState();
}

class _ComboDetailsWebPageState extends State<ComboDetailsWebPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = ResponsiveBreakpoints.isMobile(size.width);
    final isTablet = ResponsiveBreakpoints.isTablet(size.width);

    return CustomWebScaffold(
      title: widget.combo.name,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(isSmallScreen ? 20 : 25),
                        child: CachedNetworkImage(
                          imageUrl: widget.combo.image,
                          height: isSmallScreen ? 200 : 300,
                          width: isSmallScreen
                              ? size.width * 0.9
                              : (isTablet
                                  ? size.width * 0.8
                                  : size.width * 0.6),
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              Icons.error,
                              color: AppTheme.primaryBlueAccentColor,
                              size: isSmallScreen ? 24 : 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 15 : 20),

                    // Description
                    Text(
                      widget.combo.description,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 15 : 20),

                    // Events List Section
                    Text(
                      'Events included in this combo',
                      style: TextStyle(
                        color: AppTheme.inactiveColor,
                        fontSize: isSmallScreen ? 15 : 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '[Click the events to view details]',
                      style: TextStyle(
                        color: AppTheme.inactiveColor,
                        fontSize: isSmallScreen ? 11 : 12,
                      ),
                    ),
                    SizedBox(height: 15),

                    // Events List
                    SizedBox(
                      height: 22 * widget.combo.events.length.toDouble(),
                      width: isSmallScreen ? size.width * 0.9 : double.infinity,
                      child: ListView.builder(
                        itemCount: widget.combo.events.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EventDetailsPage(
                                  event: widget.combo.events[index],
                                ),
                              ),
                            ),
                            child: Text(
                              '${index + 1}. ${widget.combo.events[index].name}',
                              style: TextStyle(
                                color: AppTheme.primaryBlueAccentColor,
                                fontSize: isSmallScreen ? 16 : 18,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    AppTheme.primaryBlueAccentColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Registration Button
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: isSmallScreen ? 16 : 24,
                  ),
                  child: ComboRegistrationButton(
                    registrationOpen: widget.combo.registrationOpen,
                    combo: widget.combo,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
