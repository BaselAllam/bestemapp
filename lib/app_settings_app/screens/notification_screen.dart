import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  Map<String, dynamic> notificationData = {
    'Today': [
      {
        'title': 'Space Booked Success',
        'subtitle': 'blac blac bla bla bla bla bla',
        'date': '1H',
        'isRead': true,
        'icon': Icons.calendar_month
      },
      {
        'title': 'Space Booked Failed',
        'subtitle': 'blac blac bla bla bla bla bla',
        'date': '3H',
        'isRead': true,
        'icon': Icons.watch_later
      },
    ],
    'Yesterday': [
      {
        'title': 'Space Booked Success',
        'subtitle': 'blac blac bla bla bla bla bla',
        'date': '10:00AM',
        'isRead': true,
        'icon': Icons.calendar_month
      },
      {
        'title': 'Space Booked Failed',
        'subtitle': 'blac blac bla bla bla bla bla',
        'date': '03:00PM',
        'isRead': false,
        'icon': Icons.watch_later
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.ofWhiteColor,
        elevation: 0.0,
        title: Text(selectedLang[AppLangAssets.notification]!, style: AppFonts.primaryFontBlackColor),
        leading: BackBtn(),
        actions: [
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text('${calculateReadCount()} ${selectedLang[AppLangAssets.newNotification]}', style: AppFonts.miniFontWhiteColor),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            buildSectionTitle(selectedLang[AppLangAssets.todayNotification]!),
            for (int i = 0; i < notificationData['Today'].length; i++)
            buildNotificationItems(notificationData['Today'][i]),
            buildSectionTitle(selectedLang[AppLangAssets.yesterDataNotification]!),
            for (int i = 0; i < notificationData['Yesterday'].length; i++)
            buildNotificationItems(notificationData['Yesterday'][i]),
          ],
        ),
      ),
    );
  }

  int calculateReadCount() {
    int count = 0;
    for (String key in notificationData.keys) {
      for (var data in notificationData[key]) {
        if (!data['isRead']) {
          count++;
        }
      }
    }
    return count;
  }

  buildSectionTitle(String title) {
    return ListTile(
      title: Text(title, style: AppFonts.primaryFontBlackColor),
      trailing: Text('Mark all as read', style: AppFonts.miniFontGreyColor),
    );
  }

  buildNotificationItems(Map<String, dynamic> notificationItem) {
    return Column(
      children: [
        Container(
          color: notificationItem['isRead'] ? Colors.transparent : Colors.grey.shade200,
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              child: Icon(notificationItem['icon'], color: AppColors.primaryColor, size: 25.0),
            ),
            title: Text(notificationItem['title'], style: AppFonts.primaryFontBlackColor),
            subtitle: Text(notificationItem['subtitle'], style: AppFonts.subFontGreyColor),
            trailing: Text(notificationItem['date'], style: AppFonts.subFontGreyColor),
          ),
        ),
        Divider(endIndent: 10.0, indent: 10.0, color: AppColors.greyColor, thickness: 0.2,)
      ],
    );
  }
}