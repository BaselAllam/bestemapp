import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/notification_app/logic/notification_cubit.dart';
import 'package:bestemapp/notification_app/logic/notification_states.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/error_widget.dart';
import 'package:bestemapp/shared/shared_widgets/loading_spinner.dart';
import 'package:bestemapp/shared/shared_widgets/toaster.dart';
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.0,
        title: Text(
          selectedLang[AppLangAssets.notification]!,
          style: AppFonts.primaryFontBlackColor,
        ),
        leading: BackBtn(),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              final unreadCount = BlocProvider.of<NotificationCubit>(context).unreadNotification;
              
              if (unreadCount == 0) return const SizedBox.shrink();
              
              return Container(
                margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      selectedLang[AppLangAssets.newNotification]!,
                      style: AppFonts.miniFontWhiteColor,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is GetUserNotificationLoadingState) {
            return Center(child: CustomLoadingSpinner());
          } else if (state is GetUserNotificationErrorState ||
              state is GetUserNotificationSomeThingWentWrongState) {
            return Center(child: CustomErrorWidget());
          } else if (BlocProvider.of<NotificationCubit>(context).notifications.isEmpty) {
            return _buildEmptyState();
          } else {
            return _buildNotificationList(context);
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 80,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              selectedLang[AppLangAssets.noNotification]!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              selectedLang[AppLangAssets.noNotificationSubTitle]!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context) {
    final notificationCubit = BlocProvider.of<NotificationCubit>(context);
    
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: notificationCubit.notifications.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          if (BlocProvider.of<NotificationCubit>(context).unreadNotification > 0) {
            return _buildSectionHeader(context);
          } else {
            return SizedBox();
          }
        }
        return _buildNotificationItem(
          context,
          notificationCubit.notifications[index - 1],
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {
        if (state is MarkNotificationReadErrorState ||
            state is MarkNotificationReadSomeWentWrongState) {
          Toaster.show(
            context,
            message: selectedLang[AppLangAssets.someThingWentWrong]!,
            type: ToasterType.error,
            position: ToasterPosition.top,
          );
        } else if (state is MarkNotificationReadSuccessState) {
          Toaster.show(
            context,
            message: selectedLang[AppLangAssets.success]!,
            type: ToasterType.success,
            position: ToasterPosition.top,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is MarkNotificationReadLoadingState;
        
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Row(
            children: [
              Icon(
                Icons.today_rounded,
                size: 20,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 12),
              Text(
                isLoading
                    ? selectedLang[AppLangAssets.loading]!
                    : selectedLang[AppLangAssets.todayNotification]!,
                style: AppFonts.primaryFontBlackColor.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: isLoading
                      ? null
                      : () {
                          BlocProvider.of<NotificationCubit>(context)
                              .markNotificationRead();
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLoading)
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primaryColor,
                              ),
                            ),
                          )
                        else
                          Icon(
                            Icons.done_all_rounded,
                            size: 16,
                            color: AppColors.primaryColor,
                          ),
                        const SizedBox(width: 6),
                        Text(
                          selectedLang[AppLangAssets.markNotificationRead]!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(BuildContext context, Map<String, dynamic> notificationItem) {
    final notification = notificationItem['notification'];
    final isRead = notificationItem['is_read'];
    final notificationType = notification['notification_type'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead ? Colors.transparent : AppColors.primaryColor.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Handle notification tap
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(notificationType, isRead),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: AppFonts.primaryFontBlackColor.copyWith(
                                fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                                fontSize: 15,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isRead)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification['description'],
                        style: AppFonts.subFontGreyColor.copyWith(
                          fontSize: 14,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(notification['created_at'].toString()),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type, bool isRead) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'offers':
        iconData = Icons.local_offer_rounded;
        iconColor = Colors.orange;
        break;
      case 'news':
        iconData = Icons.newspaper_rounded;
        iconColor = Colors.blue;
        break;
      case 'other':
        iconData = Icons.cloud_rounded;
        iconColor = Colors.purple;
        break;
      default:
        iconData = Icons.notifications_rounded;
        iconColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(isRead ? 0.08 : 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return selectedLang[AppLangAssets.justNow]!;
          }
          return '${difference.inMinutes}m ${selectedLang[AppLangAssets.ago]}';
        }
        return '${difference.inHours}h ${selectedLang[AppLangAssets.ago]}';
      } else if (difference.inDays == 1) {
        return selectedLang[AppLangAssets.yesterday]!;
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ${selectedLang[AppLangAssets.ago]}';
      } else {
        return dateString.substring(0, 10);
      }
    } catch (e) {
      return dateString.substring(0, 10);
    }
  }
}