import 'dart:ffi';
import 'dart:io';
import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/shared/utils/app_api.dart';
import 'package:bestemapp/shared/utils/local_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum SearchCarParamsKeys {ad_area_id, ad_city_id, car_make_id, car_model_id, car_condition, fuel_type, transmission_type, min_price, max_price, min_year, max_year, min_kilometers, max_kilometers, sort_by, car_color__id, car_shape__id, price, negative_price, submitted_at, negative_submitted_at, kilometers}

class CarCubit extends Cubit<CarStates> {

  CarCubit() : super(InitCarStates());

  final List<String> _fuelTypes = ['all', 'gas', 'diesel', 'natural gas', 'hybird', 'electric'];
  List<String> get fuelType => _fuelTypes;

  final List<String> _conditions = ['all', 'new', 'used'];
  List<String> get conditions => _conditions;

  final List<String> _transmissions = ['all', 'manual', 'automatic'];
  List<String> get transmissions => _transmissions;

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

  int _searchCarResultsCounter = 0;
  int get searchCarResultsCounter => _searchCarResultsCounter;

  int _nextPage = 1;

  bool _isLastPage = false;
  bool get isLastPage => _isLastPage;

  void resetNextPage() {
    _nextPage = 1;
    _isLastPage = false;
  }

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
          CarAdWishlistModel newModel = CarAdWishlistModel(carAdModel: carAd, id: data['data']['id']);
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

  Map<String, dynamic> _searchCarParams = {};

  Map<String, dynamic> get searchCarParams => _searchCarParams;

  void setSearchCarParams(SearchCarParamsKeys paramKey, dynamic paramValue) {
    if (paramKey.name == SearchCarParamsKeys.sort_by.name && paramValue.toString().contains('negative')) {
      _searchCarParams[paramKey.name] = paramValue.toString().replaceFirst('negative_', '-');
    } else {
      _searchCarParams[paramKey.name] = paramValue;
    }
    _searchCarParams.removeWhere((key, value) => value == null);
    _searchCarParams.removeWhere((key, value) => value is String && value.toLowerCase() == 'all');
    emit(SetSearchCarParamState());
  }

  void clearSearchCarParams() {
    _searchCarParams.clear();
    emit(SetSearchCarParamState());
  }
  
  String _prepareSearchCarParam() {
    String searchParam = '';
    _searchCarParams.forEach((k, v) {
      searchParam = '$searchParam&$k=${v is String ? v : v is Bool ? v : v.id}';
    });
    return searchParam;
  }

  Future<void> searchCarAds() async {
    if (_isLastPage) return;
    if (_nextPage == 1) {
      _searchCarAdsResult.clear();
      emit(SearchCarAdsLoadingState());
    } else {
      emit(PaginateSearchCarAdsLoadingState());
    }
    try {
      Map<String, String> headers = AppApi.headerData;
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/cars/search_cars/?page=$_nextPage${_prepareSearchCarParam()}'), headers: headers);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        _searchCarResultsCounter = data['count'];
        _nextPage = data['next'] == null ? 1 : _nextPage++;
        if (data['next'] == null) _isLastPage = true;
        for (var i in data['results']) {
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

  Map<String, dynamic> _adDetail = {
    'detail': [],
    'related': [],
  };
  Map<String, dynamic> get adDetail => _adDetail;

  Future<void> getCarAdDetail(CarAdModel adModel) async {
    emit(CarAdsDetailLoadingState());
    _adDetail.clear();
    try {
      Map<String, String> headers = AppApi.headerData;
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/cars/car_ad_detail/?id=${adModel.id}'), headers: headers);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        CarAdModel detailObj = CarAdModel.fromJson(data['data']['detail']);
        _adDetail['detail'] = detailObj;
        List _relatedAds = [];
        for (var i in data['data']['related']) {
          CarAdModel newObj = CarAdModel.fromJson(i);
          bool isFav = handleIsFavModelValue(newObj);
          newObj.isFav = isFav;
          _relatedAds.add(newObj);
        }
        _adDetail['related'] = _relatedAds;
        emit(CarAdsDetailSuccessState());
      } else {
        emit(CarAdsDetailErrorState(data['data']));
      }
    } catch (e) {
      emit(CarAdsDetailSomeThingWentWrongState());
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

  void createCarAd({ required String adTitle, required String adDescription, required String carModel, required String carColor, required String carShape, required String adArea,
    required String carCondition, required String fuelType, required String transmissionType, required int engineCapacity, required int carYear, required int kiloMeters,
    required String price, required bool isNegotioable, File? video, required List<File> imgs, required int distanceRange, required List<Map<String, dynamic>> specsValues,
    }) async {
    emit(CreateCarAdsLoadingState());
    try {
      String userToken = await getStringFromLocal(AppApi.userToken);
      Map<String, String> headers = AppApi.headerData;
      headers['Authorization'] = 'Bearer $userToken';
      var uri = Uri.parse('${AppApi.ipAddress}/cars/user_car_ads/');
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers);

      request.fields['ad_title'] = adTitle;
      request.fields['ad_description'] = adDescription;
      request.fields['car_model'] = carModel;
      request.fields['car_color'] = carColor;
      request.fields['car_shape'] = carShape;
      request.fields['ad_area'] = adArea;
      request.fields['car_condition'] = carCondition;
      request.fields['fuel_type'] = fuelType;
      request.fields['transmission_type'] = transmissionType;
      request.fields['engine_capacity'] = engineCapacity.toString();
      request.fields['car_year'] = carYear.toString();
      request.fields['kilometers'] = kiloMeters.toString();
      request.fields['price'] = price;
      request.fields['is_negotiable'] = isNegotioable.toString();
      request.fields['distance_range'] = distanceRange.toString();
      request.fields['specs_value'] = json.encode(specsValues);
      if (video != null) {
        var videoFile = await http.MultipartFile.fromPath(
          'ad_video',
          video.path,
        );
        request.files.add(videoFile);
      }
      for (int i = 0; i < imgs.length; i++) {
        var imgFile = await http.MultipartFile.fromPath(
          'imgs',
          imgs[i].path,
        );
        request.files.add(imgFile);
      }

      http.StreamedResponse response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var data = json.decode(responseBody);
      if (response.statusCode == 201) {
        _userCarAds.insert(0, CarAdModel.fromJson(data['data']));
        emit(CreateCarAdsSuccessState());
      } else {
        emit(CreateCarAdsErrorState(data['data']));
      }
    } catch (e) {
      emit(CreateCarAdsSomeThingWentWrongState());
    }
  }

  Future<void> reportCarAd({required CarAdModel carAd, required String reason, required String comment}) async {
    emit(CreateCarAdReportLoadingState());
    try {
      String userToken = await getStringFromLocal(AppApi.userToken);
      Map<String, String> headers = AppApi.headerData;
      headers['Authorization'] = 'Bearer $userToken';
      http.Response? response = await http.post(Uri.parse('${AppApi.ipAddress}/cars/car_ad_report/'), headers: headers, body: json.encode({'car_ad': carAd.id, 'reason': reason, 'comment': comment}));
      var data = json.decode(response.body);
      if (response.statusCode == 201) {
        emit(CreateCarAdReportSuccessState());
      } else {
        emit(CreateCarAdReportErrorState(data['data']));
      }
    } catch (e) {
      emit(CreateCarAdReportSomeThingWentWrongState());
    }
  }

  void updateCarAd({ required CarAdModel carAd, required String adTitle, required String adDescription, required String carModel, required String carColor, required String carShape, required String adArea,
    required String carCondition, required String fuelType, required String transmissionType, required int engineCapacity, required int carYear, required int kiloMeters,
    required String price, required bool isNegotioable, File? video, required List<File> imgs, required int distanceRange, required List<Map<String, dynamic>> specsValues,
    required List<String> deleteImgsIds, required List<String> deleteSpecsIds
    }) async {
    emit(UpdateCarAdsLoadingState());
    try {
      String userToken = await getStringFromLocal(AppApi.userToken);
      Map<String, String> headers = AppApi.headerData;
      headers['Authorization'] = 'Bearer $userToken';
      var uri = Uri.parse('${AppApi.ipAddress}/cars/user_car_ads/');
      var request = http.MultipartRequest('PATCH', uri)
        ..headers.addAll(headers);

      if (carAd.adTitle != adTitle) request.fields['ad_title'] = adTitle;
      if (carAd.adDescription != adDescription) request.fields['ad_description'] = adDescription;
      if (carAd.carModel.id != carModel) request.fields['car_model'] = carModel;
      if (carAd.carColor.id != carColor) request.fields['car_color'] = carColor;
      if (carAd.carShape.id != carShape) request.fields['car_shape'] = carShape;
      if (carAd.adArea.id != adArea) request.fields['ad_area'] = adArea;
      if (carAd.carCondition != carCondition) request.fields['car_condition'] = carCondition;
      if (carAd.fuelType != fuelType) request.fields['fuel_type'] = fuelType;
      if (carAd.transmissionType != transmissionType) request.fields['transmission_type'] = transmissionType;
      if (carAd.engineCapacity != engineCapacity) request.fields['engine_capacity'] = engineCapacity.toString();
      if (carAd.carYear != carYear) request.fields['car_year'] = carYear.toString();
      if (carAd.kilometers != kiloMeters) request.fields['kilometers'] = kiloMeters.toString();
      if (carAd.price != price) request.fields['price'] = price;
      if (carAd.isNegotiable != isNegotioable) request.fields['is_negotiable'] = isNegotioable.toString();
      if (carAd.distanceRange != distanceRange) request.fields['distance_range'] = distanceRange.toString();
      // delete_spec_ids & specs_value
      // if (carAd.adTitle != adTitle) request.fields['specs_value'] = json.encode(specsValues);
      if (video != null) {
        var videoFile = await http.MultipartFile.fromPath(
          'ad_video',
          video.path,
        );
        request.files.add(videoFile);
      }

      // delete_img_ids & imgs
      for (int i = 0; i < imgs.length; i++) {
        var imgFile = await http.MultipartFile.fromPath(
          'imgs',
          imgs[i].path,
        );
        request.files.add(imgFile);
      }

      http.StreamedResponse response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var data = json.decode(responseBody);
      if (response.statusCode == 200) {
        for (int i = 0; i < _userCarAds.length; i++) {
          if (_userCarAds[i].id == carAd.id) {
            _userCarAds.removeAt(i);
          }
        }
        _userCarAds.insert(0, CarAdModel.fromJson(data['data']));
        emit(UpdateCarAdsSuccessState());
      } else {
        emit(UpdateCarAdsErrorState(data['data']));
      }
    } catch (e) {
      emit(UpdateCarAdsSomeThingWentWrongState());
    }
  }
}