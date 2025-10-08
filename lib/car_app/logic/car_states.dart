

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

class GetCarShapesLoadingState extends CarStates {}

class GetCarShapesSuccessState extends CarStates {}

class GetCarShapesErrorState extends CarStates {

  String errorMsg;
  GetCarShapesErrorState(this.errorMsg);
}

class GetCarShapesSomeThingWentWrongState extends CarStates {}