import 'package:flutter/cupertino.dart';
import 'package:megatronix/features/event_registration/domain/entities/event_registration_details_entity.dart';
import 'package:megatronix/features/event_registration/presentation/widgets/event_by_gid_card_tiles.dart';
import 'package:megatronix/features/events/presentation/widgets/call_button.dart';
import 'package:megatronix/theme/app_theme.dart';

class EventByGidCard extends StatefulWidget {
  final int index;
  final EventRegistrationDetailsEntity eventByGidEntity;
  const EventByGidCard({
    super.key,
    required this.index,
    required this.eventByGidEntity,
  });

  @override
  State<EventByGidCard> createState() => _EventByGidCardState();
}

class _EventByGidCardState extends State<EventByGidCard> {
  List<Color> colorizeColors = [
    AppTheme.whiteBackground,
    AppTheme.primaryBlueAccentColor,
    AppTheme.darkBackground,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CupertinoListSection.insetGrouped(
          margin: const EdgeInsets.all(5),
          backgroundColor: AppTheme.darkBackground,
          separatorColor: AppTheme.dividerColor,
          dividerMargin: -40,
          decoration: BoxDecoration(
            color: AppTheme.blackBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          header: Text(
            '${widget.index + 1}. ${widget.eventByGidEntity.eventName}',
            style: TextStyle(
              color: AppTheme.whiteBackground,
            ),
          ),
          children: [
            EventByGidCardTiles(
              leading: 'Team Name',
              title: widget.eventByGidEntity.teamName,
            ),
            EventByGidCardTiles(
              leading: 'Contacts',
              isContactField: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    widget.eventByGidEntity.contacts.map<Widget>((member) {
                  return CallButton(
                    name: member.name,
                    number: member.contact,
                  );
                }).toList(),
              ),
            ),
            EventByGidCardTiles(
              leading: 'TID',
              title: widget.eventByGidEntity.tid,
            ),
            EventByGidCardTiles(
              leading: 'GIDs',
              title: widget.eventByGidEntity.gidList,
              isGID: true,
            ),
            EventByGidCardTiles(
              leading: 'Played Status',
              title:
                  widget.eventByGidEntity.hasPlayed ? 'Played' : 'Not Played',
              isTrue: true,
            ),
            EventByGidCardTiles(
              leading: 'Qualified Status',
              title: widget.eventByGidEntity.qualified
                  ? 'Qualified'
                  : 'Not Qualified',
              isTrue: true,
            ),
            EventByGidCardTiles(
              leading: 'Position',
              title: widget.eventByGidEntity.position,
            ),
          ],
        ),
      ),
    );
  }
}
