import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/shared/utils/app_api.dart';
import 'package:bestemapp/shared/utils/local_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final List<Map<String, dynamic>> sortData = [
  {
    'title': 'Newest',
    'value': false
  },
  {
    'title': 'Lowest Price',
    'value': false
  },
  {
    'title': 'Highest Price',
    'value': false
  },
  {
    'title': 'Lowest KiloMeters',
    'value': false
  },
  {
    'title': 'Highst KiloMeters',
    'value': false
  },
  {
    'title': 'Newest Model',
    'value': false
  },
  {
    'title': 'Oldest Model',
    'value': false
  },
];

class CarCubit extends Cubit<CarStates> {

  CarCubit() : super(InitCarStates());

  List<CarShapeModel> _carShapes = [];
  List<CarShapeModel> get carShapes => _carShapes;

  List<CarSpecsModel> _carSpecs = [];
  List<CarSpecsModel> get carSpecs => _carSpecs;

  List<CarMakeModel> _carMakes = [];
  List<CarMakeModel> get carMakes => _carMakes;

  List<CarAdModel> _userCarAds = [];
  List<CarAdModel> get userCarAds => _userCarAds;

  List<CarAdModel> _searchCarAdsResult = [];
  List<CarAdModel> get searchCarAdsResult => _searchCarAdsResult;

  Map<String, List<CarAdModel>> _landingCarAdsResult = {
    'popular': <CarAdModel>[],
    'recently_added': <CarAdModel>[]
  };
  Map<String, List<CarAdModel>> get landingCarAdsResult => _landingCarAdsResult;

  List<CarAdModel> _favUserCarAds = [];
  List<CarAdModel> get favUserCarAds => _favUserCarAds;

  Future<void> getCarShapes() async {
    emit(GetCarShapesLoadingState());
    try {
      Map<String, String> headers = AppApi.headerData;
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/cars/car_shapes/'), headers: headers);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var i in data) {
          _carShapes.add(CarShapeModel.fromJson(i));
        }
        emit(GetCarShapesSuccessState());
      } else {
        emit(GetCarShapesErrorState(data['data']));
      }
    } catch (e) {
      emit(GetCarShapesSomeThingWentWrongState());
    }
  }

  Future<void> getCarSpecs() async {
    emit(GetCarSpecsLoadingState());
    try {
      Map<String, String> headers = AppApi.headerData;
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/cars/car_specs/'), headers: headers);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var i in data) {
          _carSpecs.add(CarSpecsModel.fromJson(i));
        }
        emit(GetCarSpecsSuccessState());
      } else {
        emit(GetCarSpecsErrorState(data['data']));
      }
    } catch (e) {
      emit(GetCarSpecsSomeThingWentWrongState());
    }
  }

  Future<void> getCarMakes() async {
    emit(GetCarMakesLoadingState());
    try {
      Map<String, String> headers = AppApi.headerData;
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/cars/car_makes/'), headers: headers);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var i in data) {
          _carMakes.add(CarMakeModel.fromJson(i));
        }
        emit(GetCarMakesSuccessState());
      } else {
        emit(GetCarMakesErrorState(data['data']));
      }
    } catch (e) {
      emit(GetCarMakesSomeThingWentWrongState());
    }
  }

  Future<void> handleCarAdWishlist({required CarAdModel carAdModel, String wishlistId = '', String carAd = '', int favListIndex = 0}) async {
    emit(GetCarMakesLoadingState());
    try {
      String userToken = await getStringFromLocal(AppApi.userToken);
      Map<String, String> headers = AppApi.headerData;
      headers['Authorization'] = 'Bearer $userToken';
      http.Response? response;
      if (carAdModel.isFav) {
        response = await http.delete(Uri.parse('${AppApi.ipAddress}/cars/car_wishlist/'), headers: headers, body: json.encode({'wishlist_id': wishlistId}));
      } else {
        response = await http.post(Uri.parse('${AppApi.ipAddress}/cars/car_wishlist/'), headers: headers, body: json.encode({'car_ad': carAd}));
      }
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (!carAdModel.isFav) {
          _favUserCarAds.insert(0, carAdModel);
        } else {
          _favUserCarAds.removeAt(favListIndex);
        }
        emit(GetCarMakesSuccessState());
      } else {
        emit(GetCarMakesErrorState(data['data']));
      }
    } catch (e) {
      emit(GetCarMakesSomeThingWentWrongState());
    }
  }

  Future<void> getUserCarAds() async {
    emit(GetUserCarAdsLoadingState());
    try {
      Map<String, String> headers = AppApi.headerData;
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/cars/user_car_ads/'), headers: headers);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var i in data) {
          _userCarAds.add(CarAdModel.fromJson(i));
        }
        emit(GetUserCarAdsSuccessState());
      } else {
        emit(GetUserCarAdsErrorState(data['data']));
      }
    } catch (e) {
      emit(GetUserCarAdsSomeThingWentWrongState());
    }
  }

  Future<void> searchCarAds() async {
    emit(SearchCarAdsLoadingState());
    try {
      Map<String, String> headers = AppApi.headerData;
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/cars/search_car_ads/'), headers: headers);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var i in data) {
          _searchCarAdsResult.add(CarAdModel.fromJson(i));
        }
        emit(SearchCarAdsSuccessState());
      } else {
        emit(SearchCarAdsErrorState(data['data']));
      }
    } catch (e) {
      emit(SearchCarAdsSomeThingWentWrongState());
    }
  }

  Future<void> getCarsLanding() async {
    emit(LandingCarAdsLoadingState());
    try {
      Map<String, String> headers = AppApi.headerData;
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/cars/landing_car_ads/'), headers: headers);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var i in data['popular']) {
          _landingCarAdsResult['popular']!.add(CarAdModel.fromJson(i));
        }
        for (var i in data['recently_added']) {
          _landingCarAdsResult['recently_added']!.add(CarAdModel.fromJson(i));
        }
        emit(LandingCarAdsSuccessState());
      } else {
        emit(LandingCarAdsErrorState(data['data']));
      }
    } catch (e) {
      emit(LandingCarAdsSomeThingWentWrongState());
    }
  }
}