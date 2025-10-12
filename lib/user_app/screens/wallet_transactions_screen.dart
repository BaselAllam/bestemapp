import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/custom_btn.dart';
import 'package:bestemapp/shared/shared_widgets/status_wdiget.dart';
import 'package:bestemapp/shared/utils/app_assets.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:bestemapp/user_app/screens/add_to_wallet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class WalletTransactionsScreen extends StatefulWidget {
  const WalletTransactionsScreen({super.key});

  @override
  State<WalletTransactionsScreen> createState() => _WalletTransactionsScreenState();
}

class _WalletTransactionsScreenState extends State<WalletTransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: BackBtn(),
        elevation: 0.0,
        backgroundColor: AppColors.whiteColor,
        title: Text(selectedLang[AppLangAssets.myWalletTransactions]!, style: AppFonts.primaryFontBlackColor),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              height: 160,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListTile(
                    leading: Image.asset(AppAssets.walletIcon, height: 75, width: 75.0),
                    title: Text(selectedLang[AppLangAssets.availableBalance]!, style: AppFonts.primaryFontBlackColor),
                    subtitle: Text('500 ${selectedLang[AppLangAssets.egp]}', style: AppFonts.primaryFontPrimaryColor),
                  ),
                  Opacity(
                    opacity: 0.7,
                    child: CustomBtn(
                      widget: Text('${selectedLang[AppLangAssets.addToYourWallet]}', style: AppFonts.subFontWhiteColor),
                      size: Size(250, 30),
                      color: AppColors.primaryColor,
                      radius: 20,
                      onPress: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (_) => AddToWalletScreen()));
                      }
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              title: Text(selectedLang[AppLangAssets.lastTransactions]!, style: AppFonts.primaryFontBlackColor),
            ),
            for (int i = 0; i < 10; i++)
            Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Text('500 ${selectedLang[AppLangAssets.egp]}', style: AppFonts.primaryFontBlackColor),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('12-Aug-2025', style: AppFonts.subFontGreyColor),
                    Text('*******3435', style: AppFonts.subFontGreyColor),
                  ],
                ),
                trailing: SizedBox(width: 100, height: 30, child: StatusWdiget(color: AppColors.greenColor, txt: 'Success')),
              )
            )
          ],
        ),
      ),
    );
  }
}