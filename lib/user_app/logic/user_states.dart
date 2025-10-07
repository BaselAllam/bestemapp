

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
