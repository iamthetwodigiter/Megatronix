import 'package:flutter/material.dart';
import 'package:megatronix/theme/app_theme.dart';

class EventByGidCardTiles extends StatelessWidget {
  final String leading;
  final dynamic title;
  final bool isGID;
  final bool isTrue;
  const EventByGidCardTiles({
    super.key,
    required this.leading,
    required this.title,
    this.isGID = false,
    this.isTrue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 125,
            padding: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$leading: ',
              style: TextStyle(fontSize: 12),
            ),
          ),
          !isTrue
              ? Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: isGID
                        ? (title as List).isEmpty
                            ? Text(
                                'Click me to Register',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.primaryBlueAccentColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            : SizedBox(
                                height: 50,
                                child: ListView.builder(
                                  itemCount: (title as List).length,
                                  itemBuilder: (context, index) {
                                    final gid =
                                        (title as List).elementAt(index);
                                    return Text(
                                      gid,
                                      style: TextStyle(
                                        color: AppTheme.primaryBlueAccentColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        decoration: TextDecoration.underline,
                                        decorationColor:
                                            AppTheme.primaryBlueAccentColor,
                                        decorationThickness: 0.5,
                                        decorationStyle:
                                            TextDecorationStyle.double,
                                      ),
                                    );
                                  },
                                ),
                              )
                        : Text(
                            title!.isEmpty ? 'N/A' : title!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    title!,
                    style: TextStyle(
                      color: (title! == 'Qualified' || title! == 'Played')
                          ? AppTheme.primaryGreenAccentColor
                          : AppTheme.errorColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
