import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/features/team/presentation/widgets/team_member_cards.dart';
import 'package:megatronix/features/team/providers/team_provider.dart';

class TeamPage extends ConsumerStatefulWidget {
  final bool isDeveloperPage;
  const TeamPage({super.key, required this.isDeveloperPage});

  @override
  ConsumerState<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isDeveloperPage) {
        ref.read(teamNotifierProvider.notifier).getDevelopers();
      } else {
        ref.read(teamNotifierProvider.notifier).getTeamMembers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(teamNotifierProvider);

    if (teamState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {});
      return CustomScaffold(
        title: widget.isDeveloperPage ? 'Developers' : 'Members',
        child: Center(
          child: LoadingWidget(),
        ),
      );
    }

    if (teamState.teamMembers != null && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {});
      return CustomScaffold(
        title: widget.isDeveloperPage ? 'Developers' : 'Members',
        child: teamState.teamMembers!.isEmpty
            ? Center(
                child: Text(
                  'No data found\nTry again later',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                itemCount: (teamState.teamMembers!.length + 1) ~/ 2,
                itemBuilder: (context, index) {
                  final teamMember1 = teamState.teamMembers![2 * index];
                  final teamMember2 =
                      (2 * index + 1 < teamState.teamMembers!.length)
                          ? teamState.teamMembers![2 * index + 1]
                          : null;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TeamMemberCards(teamMember: teamMember1),
                      if (teamMember2 != null)
                        TeamMemberCards(teamMember: teamMember2),
                    ],
                  );
                },
              ),
      );
    }
    return Center(
      child: Text('Failed to load team members data'),
    );
  }
}
