

abstract class NotificationState {}

class NotificationInitState extends NotificationState {}

class MarkNotificationReadSomeWentWrongState extends NotificationState {}

class MarkNotificationReadSuccessState extends NotificationState {}

class MarkNotificationReadErrorState extends NotificationState {
  String errMsg;

  MarkNotificationReadErrorState(this.errMsg);
}

class MarkNotificationReadLoadingState extends NotificationState {}

class GetUserNotificationSomeThingWentWrongState extends NotificationState {}

class GetUserNotificationSuccessState extends NotificationState {}

class GetUserNotificationErrorState extends NotificationState {
  String errMsg;

  GetUserNotificationErrorState(this.errMsg);
}

class GetUserNotificationLoadingState extends NotificationState {}