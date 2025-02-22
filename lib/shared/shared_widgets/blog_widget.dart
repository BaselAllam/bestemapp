import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/blogs_app/views/blog_details_screen.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/share_btn.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogWidget extends StatefulWidget {
  final double imgHieght;
  BlogWidget({required this.imgHieght});

  @override
  State<BlogWidget> createState() => _BlogWidgetState();
}

class _BlogWidgetState extends State<BlogWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (_) => BlogDetailsScreen()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Container(
              height: widget.imgHieght,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: NetworkImage('https://images.pexels.com/photos/97050/pexels-photo-97050.jpeg?auto=compress&cs=tinysrgb&w=800'),
                  fit: BoxFit.fill
                )
              ),
            ),
            ListTile(
              title: Text('BYD Stopped F3', style: AppFonts.primaryFontBlackColor),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('12-12-2024 - ', style: AppFonts.miniFontGreyColor),
                      Text('1000 ${selectedLang[AppLangAssets.adViews]}', style: AppFonts.miniFontGreyColor),
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        minRadius: 15,
                        maxRadius: 15,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage('https://img.youm7.com/images/graphics/logoyoum7.png'),
                      ),
                      Text('  ${selectedLang[AppLangAssets.sourceBy]}: Youm7', style: AppFonts.subFontPrimaryColor),
                    ],
                  )
                ],
              ),
              trailing: ShareBtn(),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: AppColors.primaryColor, width: 5))
              ),
              padding: BlocProvider.of<AppSettingsCubit>(context).selectedLangOption == LanguageOption.en ? EdgeInsets.only(left: 10) :  EdgeInsets.only(right:  10),
              child: Text('byd will stop byd f3 asdkladas;dsa.daslal;dsaldksalasdsadaads;asld,as;ldasd;laskd;lasdkas;ldkas;dlaskd;aldkadl;dksla;sdkasd;lask;as;ldsakd;laskd;ldasds', style: AppFonts.subFontGreyColor),
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