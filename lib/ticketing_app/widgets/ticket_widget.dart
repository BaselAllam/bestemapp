import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/status_wdiget.dart';
import 'package:bestemapp/ticketing_app/views/ticket_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class TicketWidget extends StatefulWidget {
  const TicketWidget({super.key});

  @override
  State<TicketWidget> createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (_) => TicketDetailsScreen()));
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.whiteColor
        ),
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ticket Title', style: AppFonts.primaryFontBlackColor),
                    Text('Technical', style: AppFonts.subFontBlackColor),
                  ],
                ),
                StatusWdiget(color: AppColors.greenColor, txt: 'Solved')
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.watch, color: AppColors.greyColor, size: 20),
                  Text('  12-Dec-2025', style: AppFonts.subFontGreyColor),
                ],
              ),
            ),
            Text('Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development to fill empty spaces in a layout that does not yet have content.', style: AppFonts.subFontGreyColor),
          ],
        ),
      ),
    );
  }
}