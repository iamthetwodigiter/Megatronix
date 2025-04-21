import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_web_scaffold.dart';
import 'package:megatronix/core/utils/responsive_utils.dart';
import 'package:megatronix/features/team/presentation/widgets/team_home_cards.dart';
import 'package:megatronix/features/team/providers/team_provider.dart';

class TeamHomeWebPage extends ConsumerStatefulWidget {
  final bool isMainPage;
  const TeamHomeWebPage({
    super.key,
    this.isMainPage = true,
  });

  @override
  ConsumerState<TeamHomeWebPage> createState() => _TeamHomeWebPageState();
}

class _TeamHomeWebPageState extends ConsumerState<TeamHomeWebPage> {
  String developerImage = '';
  String membersImage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamNotifierProvider.notifier).getTeamPhoto();
      selectPosterImage();
    });
  }

  void selectPosterImage() {
    final state = ref.read(teamNotifierProvider);

    final devPhotos = state.teamPhotos?.developers;
    final membersPhotos = state.teamPhotos?.members;
    Random random = Random();
    if (devPhotos != null && devPhotos.isNotEmpty) {
      int randomIndex = random.nextInt(devPhotos.length);
      setState(() {
        developerImage = devPhotos[randomIndex].photo;
      });
    }

    if (membersPhotos != null && membersPhotos.isNotEmpty) {
      int randomIndex = random.nextInt(membersPhotos.length);
      setState(() {
        membersImage = membersPhotos[randomIndex].photo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = ResponsiveBreakpoints.isMobile(size.width);
    final isTablet = ResponsiveBreakpoints.isTablet(size.width);
    return CustomWebScaffold(
      title: 'Teams',
      isMainPage: widget.isMainPage,
      child: Center(
        child: Flex(
          direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Members Card
            Flexible(
              child: SizedBox(
                width: isSmallScreen
                    ? size.width * 0.9
                    : (isTablet ? size.width * 0.45 : size.width * 0.3),
                child: TeamHomeCards(
                  title: 'Members',
                  isDeveloperPage: false,
                  photoUrl: membersImage,
                  isWebPage: true,
                  width: isSmallScreen
                      ? size.width * 0.9
                      : (isTablet ? size.width * 0.45 : size.width * 0.3),
                ),
              ),
            ),

            // Spacing between cards
            SizedBox(
              height: isSmallScreen ? 20 : 0,
              width: isSmallScreen ? 0 : 20,
            ),

            // Developers Card
            Flexible(
              child: SizedBox(
                width: isSmallScreen
                    ? size.width * 0.9
                    : (isTablet ? size.width * 0.45 : size.width * 0.3),
                child: TeamHomeCards(
                  title: 'Developers',
                  isDeveloperPage: true,
                  photoUrl: developerImage,
                  isWebPage: true,
                  width: isSmallScreen
                      ? size.width * 0.9
                      : (isTablet ? size.width * 0.45 : size.width * 0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
