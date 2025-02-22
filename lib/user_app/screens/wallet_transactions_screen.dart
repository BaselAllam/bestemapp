import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
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
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        leading: BackBtn(),
        elevation: 0.0,
        backgroundColor: AppColors.ofWhiteColor,
        title: Text(selectedLang[AppLangAssets.myWalletTransactions]!, style: AppFonts.primaryFontBlackColor),
      ),
    );
  }
}