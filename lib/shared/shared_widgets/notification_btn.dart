import 'package:bestemapp/notification_app/logic/notification_cubit.dart';
import 'package:bestemapp/notification_app/logic/notification_states.dart';
import 'package:bestemapp/notification_app/screens/notification_screen.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) => Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.whiteColor
        ),
        child: IconButton(
          icon: Badge.count(
            count: BlocProvider.of<NotificationCubit>(context).unreadNotification,
            child: const Icon(Icons.notifications_active),
            backgroundColor: AppColors.primaryColor,
          ),
          color: AppColors.primaryColor,
          iconSize: 25.0,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationScreen()));
          },
        ),
      ),
    );
  }
}