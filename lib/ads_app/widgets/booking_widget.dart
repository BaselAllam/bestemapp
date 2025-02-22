import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/custom_btn.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';


class BookingWidget extends StatefulWidget {
  final bool isHomeView;
  final bool isOtherRequest;
  BookingWidget({required this.isHomeView, this.isOtherRequest = false});

  @override
  State<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                maxRadius: 25,
                minRadius: 25,
                backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/44323531?v=4'),
              ),
              title: Text('Adam Allam', style: AppFonts.primaryFontBlackColor),
              subtitle: Text('${selectedLang[AppLangAssets.bookedAt]} 12-12-2025', style: AppFonts.miniFontGreyColor),
              trailing: Icon(Icons.arrow_outward_outlined, color: AppColors.primaryColor, size: 30.0),
            ),
            Row(
              children: [
                Text('    ${selectedLang[AppLangAssets.adsTitle]}:', style: AppFonts.miniFontBlackColor),
                Text('  Mercdes AMG for Sale', style: AppFonts.subFontGreyColor),
              ],
            ),
            Row(
              children: [
                Text('    ${selectedLang[AppLangAssets.toViewOn]}:', style: AppFonts.miniFontBlackColor),
                Text('  25-12-2025 | 5:00 PM', style: AppFonts.subFontGreyColor),
              ],
            ),
            if (!widget.isHomeView && widget.isOtherRequest)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomBtn(
                    widget: Text(selectedLang[AppLangAssets.reject]!, style: AppFonts.miniFontWhiteColor),
                    size: Size(80, 20),
                    color: AppColors.greyColor,
                    radius: 12.0,
                    onPress: () {}
                  ),
                  CustomBtn(
                    widget: Text(selectedLang[AppLangAssets.accept]!, style: AppFonts.miniFontWhiteColor),
                    size: Size(80, 20),
                    color: AppColors.greenColor,
                    radius: 12.0,
                    onPress: () {}
                  ),
                ],
              ),
            ),
            if (!widget.isHomeView && !widget.isOtherRequest)
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Row(
                children: [
                  Text('    ${selectedLang[AppLangAssets.requestStatus]}:  ', style: AppFonts.miniFontBlackColor),
                  Text('Accepted', style: AppFonts.subFontGreenColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}