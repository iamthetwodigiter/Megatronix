import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_web_scaffold.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/features/team/presentation/widgets/team_member_cards.dart';
import 'package:megatronix/features/team/providers/team_provider.dart';

class TeamWebPage extends ConsumerStatefulWidget {
  final bool isDeveloperPage;
  const TeamWebPage({
    super.key,
    required this.isDeveloperPage,
  });

  @override
  ConsumerState<TeamWebPage> createState() => _TeamWebPageState();
}

class _TeamWebPageState extends ConsumerState<TeamWebPage> {
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
      return CustomWebScaffold(
        title: widget.isDeveloperPage ? 'Developers' : 'Members',
        child: const Center(
          child: LoadingWidget(),
        ),
      );
    }

    if (teamState.teamMembers != null && context.mounted) {
      return CustomWebScaffold(
        title: widget.isDeveloperPage ? 'Developers' : 'Members',
        child: teamState.teamMembers!.isEmpty
            ? Center(
                child: Text(
                  'No data found\nTry again later',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate number of columns based on screen width
                    final crossAxisCount = switch (constraints.maxWidth) {
                      > 1500 => 4, // 4 cards per row for very large screens
                      > 1100 => 3, // 3 cards per row for large screens
                      > 700 => 2,  // 2 cards per row for medium screens
                      _ => 1,      // 1 card per row for small screens
                    };

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.8, // Adjust based on your card design
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: teamState.teamMembers!.length,
                      itemBuilder: (context, index) {
                        return TeamMemberCards(
                          teamMember: teamState.teamMembers![index],
                        );
                      },
                    );
                  },
                ),
              ),
      );
    }

    return const Center(
      child: Text('Failed to load team members data'),
    );
  }
}
