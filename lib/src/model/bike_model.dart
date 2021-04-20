class ModelSpec {
  final String name;
  final int displacement;

  ModelSpec({this.name, this.displacement});

  factory ModelSpec.fromJson(Map<String, dynamic> json) {
    return ModelSpec(
        name: json['name'],
        displacement: json['displacement']);
  }
}

class CompanyModel {
  final String company;
  final List<ModelSpec> modelSpec;

  CompanyModel({this.company, this.modelSpec});

  factory CompanyModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['model'] as List;
    print(list.runtimeType); //returns List<dynamic>
    List<ModelSpec> modelList = list.map((i) => ModelSpec.fromJson(i)).toList();
    return CompanyModel(
        company: parsedJson['company'],
         modelSpec: modelList);
        //modelSpec: ModelSpec.fromJson(parsedJson['model']));
  }
}