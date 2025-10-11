import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/notification_app/logic/notification_cubit.dart';
import 'package:bestemapp/notification_app/logic/notification_states.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/error_widget.dart';
import 'package:bestemapp/shared/shared_widgets/loading_spinner.dart';
import 'package:bestemapp/shared/shared_widgets/snack_widget.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

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
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) => Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text('${BlocProvider.of<NotificationCubit>(context).unreadNotification} ${selectedLang[AppLangAssets.newNotification]}', style: AppFonts.miniFontWhiteColor),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is GetUserNotificationLoadingState) {
              return Center(child: CustomLoadingSpinner());
            } else if (state is GetUserNotificationErrorState || state is GetUserNotificationSomeThingWentWrongState) {
              return Center(child: CustomErrorWidget());
            } else {
              return ListView(
                children: [
                  buildSectionTitle(selectedLang[AppLangAssets.todayNotification]!),
                  for (int i = 0; i < BlocProvider.of<NotificationCubit>(context).notifications.length; i++)
                  buildNotificationItems(BlocProvider.of<NotificationCubit>(context).notifications[i]),
                ],
              );
            }
          }
        ),
      ),
    );
  }

  buildSectionTitle(String title) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {
        if (state is MarkNotificationReadErrorState || state is MarkNotificationReadSomeWentWrongState) {
          ScaffoldMessenger.of(context).showSnackBar(
            snack(selectedLang[AppLangAssets.someThingWentWrong]!, AppColors.redColor)
          );
        } else if (state is MarkNotificationReadSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            snack(selectedLang[AppLangAssets.success]!, AppColors.greenColor)
          );
        }
      },
      builder: (context, state) => ListTile(
        title: Text(state is MarkNotificationReadLoadingState ? selectedLang[AppLangAssets.loading]! : title, style: AppFonts.primaryFontBlackColor),
        trailing: Text(selectedLang[AppLangAssets.markNotificationRead]!, style: AppFonts.miniFontGreyColor),
        onTap: () {
          BlocProvider.of<NotificationCubit>(context).markNotificationRead();
        },
      ),
    );
  }

  buildNotificationItems(Map<String, dynamic> notificationItem) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              child: Icon(
                notificationItem['notification']['notification_type'] == 'other' ? Icons.cloud :
                notificationItem['notification']['notification_type'] == 'offers' ? Icons.local_offer : 
                notificationItem['notification']['notification_type'] == 'news' ? Icons.newspaper : 
                Icons.more_horiz, 
                color: AppColors.primaryColor, size: 25.0),
            ),
            title: Text(notificationItem['notification']['title'], style: AppFonts.primaryFontBlackColor),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notificationItem['notification']['description'], style: AppFonts.subFontGreyColor),
                Text(notificationItem['notification']['created_at'].toString().substring(0, 10), style: AppFonts.subFontGreyColor),
              ],
            ),
            trailing: Icon(Icons.circle, color: !notificationItem['is_read'] ? AppColors.primaryColor : Colors.transparent, size: 10,)
          ),
        ),
        Divider(endIndent: 10.0, indent: 10.0, color: AppColors.greyColor, thickness: 0.2,)
      ],
    );
  }
}