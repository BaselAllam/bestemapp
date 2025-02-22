import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/rating_widget.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';


class ReviewsWidget extends StatefulWidget {
  final bool isMyView;
  const ReviewsWidget({this.isMyView = false});

  @override
  State<ReviewsWidget> createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.0)
      ),
      padding: EdgeInsets.fromLTRB(15.0, 5, 15, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage('https://avatars.githubusercontent.com/u/44323531?v=4'),
                  fit: BoxFit.contain
                )
              ),
            ),
            title: Text('Adam Allam', style: AppFonts.primaryFontBlackColor),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('12-Dec-2025', style: AppFonts.subFontGreyColor),
                RatingWidget(),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text('good seller & car was as excpected but the price is too high i will search abt another one', style: AppFonts.subFontBlackColor),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Text('${selectedLang[AppLangAssets.adsTitle]}:', style: AppFonts.miniFontBlackColor),
                    Text(' Mercdes AMG for Sale', style: AppFonts.subFontGreyColor),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: AppColors.redColor,
                iconSize: 20,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}