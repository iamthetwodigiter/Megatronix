import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/features/team/presentation/widgets/team_home_cards.dart';
import 'package:megatronix/features/team/providers/team_provider.dart';

class TeamHomePage extends ConsumerStatefulWidget {
  const TeamHomePage({super.key});

  @override
  ConsumerState<TeamHomePage> createState() => _TeamHomePageState();
}

class _TeamHomePageState extends ConsumerState<TeamHomePage> {
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

    // if (state.error != null) {
    //   AppErrorHandler.handleError(
    //     context,
    //     'Error',
    //     'Failed to load team photos. Please check your network connection.',
    //   );
    //   return;
    // }

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
    return CustomScaffold(
      title: 'Teams',
      isMainPage: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 25,
          children: [
            TeamHomeCards(
              title: 'Members',
              isDeveloperPage: false,
              photoUrl: membersImage,
            ),
            TeamHomeCards(
              title: 'Developers',
              isDeveloperPage: true,
              photoUrl: developerImage,
            ),
          ],
        ),
      ),
    );
  }
}
