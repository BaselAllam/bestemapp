

import 'package:bestemapp/car_app/logic/car_model.dart';

abstract class CarStates {}

class InitCarStates extends CarStates{}

class GetCarSpecsLoadingState extends CarStates {}

class GetCarSpecsSuccessState extends CarStates {}

class GetCarSpecsErrorState extends CarStates {

  String errorMsg;
  GetCarSpecsErrorState(this.errorMsg);
}

class GetCarSpecsSomeThingWentWrongState extends CarStates {}

class GetCarMakesLoadingState extends CarStates {}

class GetCarMakesSuccessState extends CarStates {}

class GetCarMakesErrorState extends CarStates {

  String errorMsg;
  GetCarMakesErrorState(this.errorMsg);
}

class GetCarMakesSomeThingWentWrongState extends CarStates {}

class CreateCarAdReportLoadingState extends CarStates {}

class CreateCarAdReportSuccessState extends CarStates {}

class CreateCarAdReportErrorState extends CarStates {

  String errorMsg;
  CreateCarAdReportErrorState(this.errorMsg);
}

class CreateCarAdReportSomeThingWentWrongState extends CarStates {}

class GetCarShapesLoadingState extends CarStates {}

class GetCarShapesSuccessState extends CarStates {}

class GetCarShapesErrorState extends CarStates {

  String errorMsg;
  GetCarShapesErrorState(this.errorMsg);
}

class GetCarShapesSomeThingWentWrongState extends CarStates {}

class HandleCardAdWishlistLoadingState extends CarStates {}

class HandleCardAdWishlistSuccessState extends CarStates {}

class HandleCardAdWishlistErrorState extends CarStates {

  String errorMsg;
  HandleCardAdWishlistErrorState(this.errorMsg);
}

class HandleCardAdWishlistSomeThingWentWrongState extends CarStates {}

class GetUserCarAdsLoadingState extends CarStates {}

class GetUserCarAdsSuccessState extends CarStates {}

class GetUserCarAdsErrorState extends CarStates {

  String errorMsg;
  GetUserCarAdsErrorState(this.errorMsg);
}

class GetUserCarAdsSomeThingWentWrongState extends CarStates {}

class GetUserCarWishlistAdsLoadingState extends CarStates {}

class GetUserCarWishlistAdsSuccessState extends CarStates {}

class GetUserCarWishlistAdsErrorState extends CarStates {

  String errorMsg;
  GetUserCarWishlistAdsErrorState(this.errorMsg);
}

class GetUserCarWishlistAdsSomeThingWentWrongState extends CarStates {}

class SearchCarAdsState extends CarStates {
  final List<CarAdModel> results;
  final bool isInitialLoading;
  final bool isPaginating;
  final bool isSearchLoading;
  final bool isLastPage;
  final int totalCount;
  final String? error;

  SearchCarAdsState({
    this.results = const [],
    this.isInitialLoading = false,
    this.isPaginating = false,
    this.isSearchLoading = false,
    this.isLastPage = false,
    this.totalCount = 0,
    this.error,
  });

  SearchCarAdsState copyWith({
    List<CarAdModel>? results,
    bool? isInitialLoading,
    bool? isPaginating,
    bool? isSearchLoading,
    bool? isLastPage,
    int? totalCount,
    String? error,
  }) {
    return SearchCarAdsState(
      results: results ?? this.results,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      isLastPage: isLastPage ?? this.isLastPage,
      totalCount: totalCount ?? this.totalCount,
      error: error,
    );
  }
}

class CarAdsDetailLoadingState extends CarStates {}

class CarAdsDetailSuccessState extends CarStates {}

class CarAdsDetailErrorState extends CarStates {

  String errorMsg;
  CarAdsDetailErrorState(this.errorMsg);
}

class CarAdsDetailSomeThingWentWrongState extends CarStates {}

class SetSearchCarParamState extends CarStates {}

class LandingCarAdsLoadingState extends CarStates {}

class LandingCarAdsSuccessState extends CarStates {}

class LandingCarAdsErrorState extends CarStates {

  String errorMsg;
  LandingCarAdsErrorState(this.errorMsg);
}

class LandingCarAdsSomeThingWentWrongState extends CarStates {}

class CreateCarAdsLoadingState extends CarStates {}

class CreateCarAdsSuccessState extends CarStates {}

class CreateCarAdsErrorState extends CarStates {

  String errorMsg;
  CreateCarAdsErrorState(this.errorMsg);
}

class CreateCarAdsSomeThingWentWrongState extends CarStates {}

class UpdateCarAdsLoadingState extends CarStates {}

class UpdateCarAdsSuccessState extends CarStates {}

class UpdateCarAdsErrorState extends CarStates {

  String errorMsg;
  UpdateCarAdsErrorState(this.errorMsg);
}

class UpdateCarAdsSomeThingWentWrongState extends CarStates {}