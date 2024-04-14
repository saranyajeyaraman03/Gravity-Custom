class Car {
  final String id;
  final String carBrand;
  final String carModel;
  final String carModelYear;
  final String carType;

  Car({
    required this.id,
    required this.carBrand,
    required this.carModel,
    required this.carModelYear,
    required this.carType,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] ?? '',
      carBrand: json['car_brand'] ?? '',
      carModel: json['car_model'] ?? '',
      carModelYear: json['car_model_year'] ?? '',
      carType: json['car_type'] ?? '',
    );
  }
}
