

abstract class UserStates {}

class InitialUserState extends UserStates {}

class LoginLoadingState extends UserStates {}

class LoginSuccessState extends UserStates {}

class LoginOTPState extends UserStates {}

class LoginSomeThingWentWrongState extends UserStates {}

class LoginErrorState extends UserStates {
  String errMsg;

  LoginErrorState(this.errMsg);
}

class RegisterLoadingState extends UserStates {}

class RegisterSuccessState extends UserStates {}

class RegisterSomeThingWentWrongState extends UserStates {}

class RegisterErrorState extends UserStates {
  String errMsg;

  RegisterErrorState(this.errMsg);
}

class LogoutLoadingState extends UserStates {}

class LogoutSuccessState extends UserStates {}

class LogoutSomeThingWentWrongState extends UserStates {}

class LogoutErrorState extends UserStates {
  String errMsg;

  LogoutErrorState(this.errMsg);
}

class GetUserDataLoadingState extends UserStates {}

class GetUserDataSuccessState extends UserStates {}

class GetUserDataSomeThingWentWrongState extends UserStates {}

class GetUserDataErrorState extends UserStates {
  String errMsg;

  GetUserDataErrorState(this.errMsg);
}

class UpdateUserDataLoadingState extends UserStates {}

class UpdateUserDataSuccessState extends UserStates {}

class UpdateUserDataSomeThingWentWrongState extends UserStates {}

class UpdateUserDataErrorState extends UserStates {
  String errMsg;

  UpdateUserDataErrorState(this.errMsg);
}