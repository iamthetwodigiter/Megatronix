import 'package:flutter/cupertino.dart';
import 'package:megatronix/common/widgets/custom_richtext.dart';
import 'package:megatronix/features/event_registration/domain/entities/event_registration_details_entity.dart';
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
      height: 275,
      width: size.width,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.index + 1}. ${widget.eventByGidEntity.eventName}',
            style: TextStyle(
              color: AppTheme.primaryBlueAccentColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          CustomRichtext(
            title: '- Team Name',
            subtitle: widget.eventByGidEntity.teamName,
          ),
          CustomRichtext(
            title: '- Contacts',
            subtitle:
                widget.eventByGidEntity.contacts.map((e) => e.name).join(", "),
          ),
          CustomRichtext(
            title: '- TID',
            subtitle: widget.eventByGidEntity.tid,
          ),
          CustomRichtext(
            title: '- GID List',
            subtitle: '\n${widget.eventByGidEntity.gidList.join("\n")}',
          ),
          CustomRichtext(
            title: '- Played Status',
            subtitle:
                widget.eventByGidEntity.hasPlayed ? 'Played' : 'Not Played',
          ),
          CustomRichtext(
            title: '- Paid Status',
            subtitle: widget.eventByGidEntity.paid ? 'Paid' : 'Not Paid',
          ),
          CustomRichtext(
            title: '- Qualified Status',
            subtitle: widget.eventByGidEntity.qualified
                ? 'Qualified'
                : 'Not Qualified',
          ),
          CustomRichtext(
            title: '- Position',
            subtitle: widget.eventByGidEntity.position,
          ),
        ],
      ),
    );
  }
}
