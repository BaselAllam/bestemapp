import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/custom_btn.dart';
import 'package:bestemapp/shared/shared_widgets/field.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';


class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {

  TextEditingController ticketTitleController = TextEditingController();
  TextEditingController ticketDescriptionController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String ticketType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        leading: BackBtn(),
        elevation: 0.0,
        backgroundColor: AppColors.ofWhiteColor,
        title: Text(selectedLang[AppLangAssets.createNewTicket]!, style: AppFonts.primaryFontBlackColor),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              authField(
                title: selectedLang[AppLangAssets.ticketTitle]!,
                inputTitle: selectedLang[AppLangAssets.ticketTitle]!,
                inputStyle: AppFonts.subFontGreyColor,
                fillColor: AppColors.whiteColor,
                textInputAction: TextInputAction.done,
                keyBoardType: TextInputType.number,
                controller: ticketTitleController,
                formaters: [],
              ),
              authField(
                title: selectedLang[AppLangAssets.ticketDescription]!,
                inputTitle: selectedLang[AppLangAssets.ticketDescription]!,
                inputStyle: AppFonts.subFontGreyColor,
                fillColor: AppColors.whiteColor,
                textInputAction: TextInputAction.done,
                keyBoardType: TextInputType.text,
                controller: ticketDescriptionController,
                formaters: [],
              ),
              ListTile(
              title: Text(selectedLang[AppLangAssets.ticketType]!, style: AppFonts.primaryFontBlackColor),
              subtitle: Text(ticketType, style: AppFonts.subFontGreyColor),
              trailing: PopupMenuButton(
                color: AppColors.ofWhiteColor,
                icon: Icon(Icons.arrow_downward, color: AppColors.primaryColor, size: 20.0),
                onSelected: (value) {
                  ticketType = value;
                  setState(() {});
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem(
                      child: Text(selectedLang[AppLangAssets.technical]!, style: AppFonts.subFontBlackColor),
                      value: selectedLang[AppLangAssets.technical]!,
                    ),
                    PopupMenuItem(
                      child: Text(selectedLang[AppLangAssets.payment]!, style: AppFonts.subFontBlackColor),
                      value: selectedLang[AppLangAssets.payment]!,
                    ),
                    PopupMenuItem(
                      child: Text(selectedLang[AppLangAssets.other]!, style: AppFonts.subFontBlackColor),
                      value: selectedLang[AppLangAssets.other]!,
                    ),
                  ];
                },
              ),
            ),
              SizedBox(height: 45.0),
              Column(
                children: [
                  CustomBtn(
                    widget: Text(selectedLang[AppLangAssets.submitTicket]!, style: AppFonts.subFontWhiteColor),
                    size: Size(MediaQuery.of(context).size.width / 1.15, 48),
                    color: AppColors.primaryColor,
                    radius: 12.0,
                    onPress: () async {
                      
                    }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}