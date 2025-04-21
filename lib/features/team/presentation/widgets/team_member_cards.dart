import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:megatronix/common/widgets/custom_image.dart';
import 'package:megatronix/common/widgets/social_button.dart';
import 'package:megatronix/features/team/domain/entities/team_entity.dart';
import 'package:megatronix/theme/app_theme.dart';

class TeamMemberCards extends StatefulWidget {
  final TeamEntity teamMember;
  const TeamMemberCards({
    super.key,
    required this.teamMember,
  });

  @override
  State<TeamMemberCards> createState() => _TeamMemberCardsState();
}

class _TeamMemberCardsState extends State<TeamMemberCards> {
  String formatYear(String str) {
    String year = '';
    switch (str) {
      case 'SECOND':
        year = '2nd';
      case 'THIRD':
        year = '3rd';
      case 'FOURTH':
        year = '4th';
    }
    return year;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final fileID = widget.teamMember.profile
        .substring(widget.teamMember.profile.lastIndexOf("=") + 1);

    final imageUrl = widget.teamMember.profile.isNotEmpty
        ? 'https://drive.google.com/uc?export=view&id=$fileID'
        : 'https://res.cloudinary.com/drxvzwtfr/image/upload/v1743156535/paridhi-2025/events/Screenshot%202025-01-26%20003256.png';

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: AppTheme.scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CustomImage(
                      image: imageUrl,
                      height: 300,
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.teamMember.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${formatYear(widget.teamMember.year)} Year',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.inactiveColor,
                    ),
                  ),
                   SizedBox(height: 8),
                  Text(
                    widget.teamMember.designation ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.inactiveColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (widget.teamMember.facebook.isNotEmpty)
                        SocialButton(
                          url: widget.teamMember.facebook,
                          icon: HugeIcons.strokeRoundedFacebook02,
                          platform: 'Facebook',
                          iconSize: 25,
                          iconBgColor: AppTheme.primaryBlueAccentColor,
                        ),
                      if (widget.teamMember.instagram.isNotEmpty)
                        SocialButton(
                          url: widget.teamMember.instagram,
                          icon: HugeIcons.strokeRoundedInstagram,
                          platform: 'Instagram',
                          iconSize: 25,
                          iconBgColor: AppTheme.primaryBlueAccentColor,
                        ),
                      if (widget.teamMember.linkedIn.isNotEmpty)
                        SocialButton(
                          url: widget.teamMember.linkedIn,
                          icon: HugeIcons.strokeRoundedLinkedin01,
                          platform: 'LinkedIn',
                          iconSize: 25,
                          iconBgColor: AppTheme.primaryBlueAccentColor,
                        ),
                      if (widget.teamMember.github.isNotEmpty)
                        SocialButton(
                          url: widget.teamMember.github,
                          icon: HugeIcons.strokeRoundedGithub,
                          platform: 'GitHub',
                          iconSize: 25,
                          iconBgColor: AppTheme.primaryBlueAccentColor,
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 235,
        width: size.width / 2.2,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryBlueAccentColor,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(170, 241, 241, 241),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                      ),
                    ),
                    Container(
                      height: 121,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlueAccentColor.withAlpha(150),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child: CustomImage(
                          image: widget.teamMember.profile,
                          height: 110,
                          width: 110,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        widget.teamMember.name,
                        style: TextStyle(
                          color: AppTheme.whiteBackground,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${formatYear(widget.teamMember.year)} Year',
                        style: TextStyle(
                          color: AppTheme.whiteBackground,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: Icon(
                    Icons.info,
                    size: 20,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppTheme.primaryBlueAccentColor,
                    width: 4,
                  ),
                  right: BorderSide(
                    color: AppTheme.primaryBlueAccentColor,
                    width: 4,
                  ),
                ),
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: AppTheme.whiteBackground,
                    width: 4,
                  ),
                  bottom: BorderSide(
                    color: AppTheme.whiteBackground,
                    width: 4,
                  ),
                ),
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
