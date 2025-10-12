import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/shared/utils/app_api.dart';
import 'package:bestemapp/shared/utils/local_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


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

  List<CarAdWishlistModel> _userWishlistCarAds = [];
  List<CarAdWishlistModel> get userWishlistCarAds => _userWishlistCarAds;

  List<CarAdModel> _searchCarAdsResult = [];
  List<CarAdModel> get searchCarAdsResult => _searchCarAdsResult;

  int _carAdsCount = 0;
  int get carAdsCount => _carAdsCount;

  int _usersCount = 0;
  int get usersCount => _usersCount;

  Map<String, List<CarAdModel>> _landingCarAdsResult = {
    'popular': <CarAdModel>[],
    'recently_added': <CarAdModel>[]
  };
  Map<String, List<CarAdModel>> get landingCarAdsResult => _landingCarAdsResult;

  Future<void> getCarShapes() async {
    emit(GetCarShapesLoadingState());
    try {
      Map<String, String> headers = AppApi.headerData;
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/cars/car_shapes/'), headers: headers);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var i in data['data']) {
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
        for (var i in data['data']) {
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
        for (var i in data['data']) {
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

  bool handleIsFavModelValue(CarAdModel adModel) {
    for (int i = 0; i < _userWishlistCarAds.length; i++) {
      if (_userWishlistCarAds[i].carAdModel.id == adModel.id) {
        return true;
      }
    }
    return false;
  }

  Future<void> handleCarAdWishlist({required CarAdModel carAd}) async {
    emit(GetCarMakesLoadingState());
    try {
      String userToken = await getStringFromLocal(AppApi.userToken);
      Map<String, String> headers = AppApi.headerData;
      headers['Authorization'] = 'Bearer $userToken';
      http.Response? response;
      CarAdWishlistModel? wishlistModel;
      int index = 0;
      for (int i = 0; i < _userWishlistCarAds.length; i++) {
        if (_userWishlistCarAds[i].carAdModel.id == carAd.id) {
          wishlistModel = _userWishlistCarAds[i];
          index = i;
        }
      }
      if (carAd.isFav) {
        response = await http.delete(Uri.parse('${AppApi.ipAddress}/cars/car_wishlist/'), headers: headers, body: json.encode({'wishlist_id': wishlistModel!.id}));
      } else {
        response = await http.post(Uri.parse('${AppApi.ipAddress}/cars/car_wishlist/'), headers: headers, body: json.encode({'car_ad': carAd.id}));
      }
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (!carAd.isFav) {
          CarAdWishlistModel newModel = CarAdWishlistModel(carAdModel: CarAdModel.fromJson(data['data']['car_ad']), id: data['data']['id']);
          _userWishlistCarAds.insert(0, newModel);
          carAd.isFav = true;
        } else {
          _userWishlistCarAds.removeAt(index);
          carAd.isFav = false;
        }
        emit(GetCarMakesSuccessState());
      } else {
        emit(GetCarMakesErrorState(data['data']));
      }
    } catch (e) {
      emit(GetCarMakesSomeThingWentWrongState());
    }
  }

  Future<void> getUserCarAdsWihslist() async {
    emit(GetUserCarWishlistAdsLoadingState());
    try {
      String userToken = await getStringFromLocal(AppApi.userToken);
      Map<String, String> headers = AppApi.headerData;
      headers['Authorization'] = 'Bearer $userToken';
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/cars/car_wishlist/'), headers: headers);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var i in data['data']) {
          CarAdWishlistModel new_obj = CarAdWishlistModel(id: i['id'], carAdModel: CarAdModel.fromJson(i['car_ad']));
          new_obj.carAdModel.isFav = true;
          _userWishlistCarAds.add(new_obj);
        }
        emit(GetUserCarWishlistAdsSuccessState());
      } else {
        emit(GetUserCarWishlistAdsErrorState(data['data']));
      }
    } catch (e) {
      emit(GetUserCarWishlistAdsSomeThingWentWrongState());
    }
  }

  Future<void> getUserCarAds() async {
    emit(GetUserCarAdsLoadingState());
    try {
      String userToken = await getStringFromLocal(AppApi.userToken);
      Map<String, String> headers = AppApi.headerData;
      headers['Authorization'] = 'Bearer $userToken';
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/cars/user_car_ads/'), headers: headers);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var i in data['data']) {
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
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/cars/search_cars/'), headers: headers);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var i in data['data']) {
          CarAdModel newObj = CarAdModel.fromJson(i);
          bool isFav = handleIsFavModelValue(newObj);
          newObj.isFav = isFav;
          _searchCarAdsResult.add(newObj);
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
        _carAdsCount = data['data']['cars_count'];
        _usersCount = data['data']['users_count'];
        for (var i in data['data']['popular']) {
          CarAdModel newObj = CarAdModel.fromJson(i);
          bool isFav = handleIsFavModelValue(newObj);
          newObj.isFav = isFav;
          _landingCarAdsResult['popular']!.add(newObj);
        }
        for (var i in data['data']['recently_added']) {
          CarAdModel newObj = CarAdModel.fromJson(i);
          bool isFav = handleIsFavModelValue(newObj);
          newObj.isFav = isFav;
          _landingCarAdsResult['recently_added']!.add(newObj);
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