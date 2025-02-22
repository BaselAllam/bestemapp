import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/share_btn.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BlogDetailsScreen extends StatefulWidget {
  const BlogDetailsScreen({super.key});

  @override
  State<BlogDetailsScreen> createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.ofWhiteColor,
        elevation: 0.0,
        title: Text(selectedLang[AppLangAssets.blogsDetails]!, style: AppFonts.primaryFontBlackColor),
        leading: BackBtn(),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
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
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://img.youm7.com/images/graphics/logoyoum7.png'),
                            fit: BoxFit.contain
                          )
                        ),
                      ),
                      Text('  ${selectedLang[AppLangAssets.sourceBy]}: Youm7', style: AppFonts.subFontBlackColor),
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
              child: Text('''
byd will stop byd f3 asdkladas;dsa.daslal;dsaldksalasdsadaads;asld,as;ldasd;laskd;lasdkas;ldkas;dlaskd;aldkadl;dksla;sdkasd;lask;as;ldsakd;laskd;ldasds
byd will stop byd f3 asdkladas;dsa.daslal;dsaldksalasdsadaads;asld,as;ldasd;laskd;lasdkas;ldkas;dlaskd;aldkadl;dksla;sdkasd;lask;as;ldsakd;laskd;ldasds
byd will stop byd f3 asdkladas;dsa.daslal;dsaldksalasdsadaads;asld,as;ldasd;laskd;lasdkas;ldkas;dlaskd;aldkadl;dksla;sdkasd;lask;as;ldsakd;laskd;ldasds
byd will stop byd f3 asdkladas;dsa.daslal;dsaldksalasdsadaads;asld,as;ldasd;laskd;lasdkas;ldkas;dlaskd;aldkadl;dksla;sdkasd;lask;as;ldsakd;laskd;ldasds
byd will stop byd f3 asdkladas;dsa.daslal;dsaldksalasdsadaads;asld,as;ldasd;laskd;lasdkas;ldkas;dlaskd;aldkadl;dksla;sdkasd;lask;as;ldsakd;laskd;ldasds
byd will stop byd f3 asdkladas;dsa.daslal;dsaldksalasdsadaads;asld,as;ldasd;laskd;lasdkas;ldkas;dlaskd;aldkadl;dksla;sdkasd;lask;as;ldsakd;laskd;ldasds
''', style: AppFonts.subFontGreyColor),
            ),
          ],
        ),
      ),
    );
  }
}