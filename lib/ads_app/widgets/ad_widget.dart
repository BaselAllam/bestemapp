import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/fav_widget.dart';
import 'package:bestemapp/shared/shared_widgets/share_btn.dart';
import 'package:bestemapp/shared/utils/app_assets.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';

class AdWidget extends StatefulWidget {
  final double imgHieght;
  final bool isAdminView;
  AdWidget({required this.imgHieght, this.isAdminView = false});

  @override
  State<AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
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
          children: [
            ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.greyColor, width: 0.5)
                ),
                padding: EdgeInsets.all(3.0),
                child: CircleAvatar(
                  minRadius: 20,
                  maxRadius: 20,
                  backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8XbaDblmK0KlEgSV1hI0-hlBddRQEW-OR5Q&s'),
                ),
              ),
              title: Text('Mercedes AMG for Sale', style: AppFonts.subFontBlackColor),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('E300', style: AppFonts.subFontPrimaryColor),
                      Text(' - 1K ${selectedLang[AppLangAssets.adViews]}', style: AppFonts.miniFontGreyColor),
                      Text(' - 1M ${selectedLang[AppLangAssets.booking]}', style: AppFonts.miniFontGreyColor),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Cairo, Nasr City ', style: AppFonts.miniFontGreyColor),
                      Text(' - 12-12-2024', style: AppFonts.miniFontGreyColor),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: widget.imgHieght,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: NetworkImage('https://images.pexels.com/photos/112460/pexels-photo-112460.jpeg?auto=compress&cs=tinysrgb&w=600'),
                  fit: BoxFit.fill
                )
              ),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShareBtn(),
                  if (widget.isAdminView)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      shape: BoxShape.circle
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      color: AppColors.greyColor,
                      iconSize: 15.0,
                      onPressed: () {},
                    ),
                  ),
                  if (!widget.isAdminView)
                  FavButton(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                sepcsItem('25000 KM'),
                sepcsItem('2022'),
                sepcsItem('Used'),
                sepcsItem('Manual'),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                sepcsItem('Air Bag'),
                sepcsItem('ABS'),
                sepcsItem('EBD'),
                sepcsItem('Sensors'),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: AppColors.primaryColor, width: 5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(AppAssets.moneyIcon, height: 30.0, width: 30.0),
                      Text('  25000 EGP', style: AppFonts.primaryFontPrimaryColor),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5.0),
                    child: Text('Negotiable 👌🏻', style: AppFonts.miniFontWhiteColor)
                  ),
                  if (widget.isAdminView)
                  Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      color: AppColors.greenColor,
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5.0),
                    child: Text('Active Ad', style: AppFonts.miniFontWhiteColor)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  sepcsItem(String title) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ofWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(5.0),
      height: 30.0,
      width: title.length * 12,
      alignment: Alignment.center,
      child: Text(title, style: AppFonts.miniFontGreyColor),
    );
  }
}