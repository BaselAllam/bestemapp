import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:bestemapp/store_app/views/add_address_screen.dart';
import 'package:bestemapp/store_app/widgets/address_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MyAddressesScreen extends StatefulWidget {
  const MyAddressesScreen({super.key});

  @override
  State<MyAddressesScreen> createState() => _MyAddressesScreenState();
}

class _MyAddressesScreenState extends State<MyAddressesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        leading: BackBtn(),
        elevation: 0.0,
        backgroundColor: AppColors.ofWhiteColor,
        title: Text(selectedLang[AppLangAssets.myAddresses]!, style: AppFonts.primaryFontBlackColor),
        actions: [
          Container(
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.whiteColor
            ),
            child: IconButton(
              icon: const Icon(Icons.add),
              color: AppColors.primaryColor,
              iconSize: 30.0,
              onPressed: () {
                Navigator.push(context, CupertinoPageRoute(builder: (_) => AddAddressScreen()));
              },
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, state) => AddressWidget(),
        ),
      ),
    );
  }
}