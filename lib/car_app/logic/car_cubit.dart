import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/shared/utils/app_api.dart';
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
}