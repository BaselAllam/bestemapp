import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/status_wdiget.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';


class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({super.key});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        leading: BackBtn(),
        elevation: 0.0,
        backgroundColor: AppColors.ofWhiteColor,
        title: Text(selectedLang[AppLangAssets.ticketDetails]!, style: AppFonts.primaryFontBlackColor),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            ListTile(
                title: Text('${selectedLang[AppLangAssets.ticketTitle]!}:', style: AppFonts.subFontGreyColor),
                subtitle: Text('Tech Ticket Title', style: AppFonts.primaryFontBlackColor),
            ),
            ListTile(
                title: Text('${selectedLang[AppLangAssets.ticketDate]!}:', style: AppFonts.subFontGreyColor),
                subtitle: Text('12-1-2025', style: AppFonts.primaryFontBlackColor),
            ),
            ListTile(
                title: Text('${selectedLang[AppLangAssets.ticketDescription]!}:', style: AppFonts.subFontGreyColor),
                subtitle: Text(
                  'Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development to fill empty spaces in a layout that does not yet have content.',
                  style: AppFonts.primaryFontBlackColor
                ),
            ),
            ListTile(
                title: Text('${selectedLang[AppLangAssets.ticketStatus]!}:', style: AppFonts.subFontGreyColor),
                trailing: SizedBox(width: 100, height: 30.0, child: StatusWdiget(color: AppColors.greenColor, txt: 'Solved'))
            ),
            ListTile(
                title: Text('${selectedLang[AppLangAssets.ticketResponse]!}:', style: AppFonts.subFontGreyColor),
                subtitle: Text(
                  'Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development to fill empty spaces in a layout that does not yet have content.',
                  style: AppFonts.primaryFontBlackColor
                ),
            ),
          ],
        ),
      ),
    );
  }
}