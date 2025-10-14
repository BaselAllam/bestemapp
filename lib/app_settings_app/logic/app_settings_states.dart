

abstract class AppSettingsStates {}

class InitAppSettingsState extends AppSettingsStates {}

class ChangeOnBoardingAppSettingsState extends AppSettingsStates {}

class ChangeHomeFilterState extends AppSettingsStates {}

class ChangeLanguageState extends AppSettingsStates {}

class ChangeNavState extends AppSettingsStates {}

class GetFaqLoadingState extends AppSettingsStates {}

class GetFaqSuccessState extends AppSettingsStates {}

class GetFaqErrorState extends AppSettingsStates {

  String errorMsg;
  GetFaqErrorState(this.errorMsg);
}

class GetFaqSomeThingWentWrongState extends AppSettingsStates {}


class GetCountriesLoadingState extends AppSettingsStates {}

class GetCountriesSuccessState extends AppSettingsStates {}

class GetCountriesErrorState extends AppSettingsStates {

  String errorMsg;
  GetCountriesErrorState(this.errorMsg);
}

class GetCountriesSomeThingWentWrongState extends AppSettingsStates {}

class GetColorsLoadingState extends AppSettingsStates {}

class GetColorsSuccessState extends AppSettingsStates {}

class GetColorsErrorState extends AppSettingsStates {

  String errorMsg;
  GetColorsErrorState(this.errorMsg);
}

class GetColorsSomeThingWentWrongState extends AppSettingsStates {}


class GetLandingBannersLoadingState extends AppSettingsStates {}

class GetLandingBannersSuccessState extends AppSettingsStates {}

class GetLandingBannersErrorState extends AppSettingsStates {

  String errorMsg;
  GetLandingBannersErrorState(this.errorMsg);
}

class GetLandingBannersSomeThingWentWrongState extends AppSettingsStates {}