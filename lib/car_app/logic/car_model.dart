

class CarAdModel {
  final String id;
  bool isFav;

  CarAdModel({required this.id, required this.isFav});
}

class CarSpecsModel {
  final String id;
  final String spec;
  final String specType;

  CarSpecsModel({
    required this.id,
    required this.spec,
    required this.specType,
  });

  factory CarSpecsModel.fromJson(Map<String, dynamic> json) {
    return CarSpecsModel(
      id: json['id'] ?? '',
      spec: json['spec'] ?? '',
      specType: json['spec_type'] ?? '',
    );
  }
}

class CarShapeModel {
  final String id;
  final String shapeName;
  final String shapeIcon;

  CarShapeModel({
    required this.id,
    required this.shapeName,
    required this.shapeIcon,
  });

  factory CarShapeModel.fromJson(Map<String, dynamic> json) {
    return CarShapeModel(
      id: json['id'] ?? '',
      shapeName: json['shape_name'] ?? '',
      shapeIcon: json['shape_icon'] ?? '',
    );
  }
}

class CarMakeModel {
  final String id;
  final String makeName;
  final String makeLogo;
  final List<CarMakeModelModel> models;

  CarMakeModel({
    required this.id,
    required this.makeName,
    required this.makeLogo,
    required this.models,
  });

  factory CarMakeModel.fromJson(Map<String, dynamic> json) {
    return CarMakeModel(
      id: json['id'] ?? '',
      makeName: json['make_name'] ?? '',
      makeLogo: json['make_logo'] ?? '',
      models: (json['models'] as List<dynamic>?)
              ?.map((m) => CarMakeModelModel.fromJson(m))
              .toList() ??
          [],
    );
  }
}

class CarMakeModelModel {
  final String id;
  final String modelName;

  CarMakeModelModel({
    required this.id,
    required this.modelName,
  });

  factory CarMakeModelModel.fromJson(Map<String, dynamic> json) {
    return CarMakeModelModel(
      id: json['id'] ?? '',
      modelName: json['model_name'] ?? '',
    );
  }
}
