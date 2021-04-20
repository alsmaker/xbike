import 'package:xbike/src/page/register_basic.dart';

class SalesItem {
  final String key;
  final String company;
  final String model;
  final int displacement;
  final int birthYear;
  final int milage;
  final int amount;
  final String sido;
  final String gungu;
  final GearType gearType;
  final FuelType fuelType;
  final IsTuned isTuned;
  final PossibleAS possibleAS;
  final String comment;
  final List<String> imageList;
  final String createdTime;

  SalesItem({this.key, this.company, this.model, this.displacement,
     this.birthYear, this.milage, this.amount, this.sido, this.gungu,
    this.gearType, this.fuelType, this.isTuned, this.possibleAS, this.comment, this.imageList, this.createdTime});


  factory SalesItem.fromJson(Map<String, dynamic> json) => SalesItem(
    key: json["key"],
    amount: json["amount"],
    birthYear: json["birthYear"],
    comment: json["comment"],
    company: json["company"],
    //createdTime: DateTime.parse(json["createdTime"]),
    displacement: json["displacement"],
    //fuelType: json["fuelType"],
    //gearType: json["gearType"],
    gungu: json["gungu"],
    imageList: List<String>.from(json["imageList"].map((x) => x)),
    //isTuned: json["isTuned"],
    milage: json["milage"],
    model: json["model"],
    //possibleAS: json["possibleAS"],
    sido: json["sido"],
  );

  toJson() {
    return {
      'key': key,
      'company' : company,
      'model' : model,
      'displacement' : displacement,
      'birthYear' : birthYear,
      'milage' : milage,
      'amount' : amount,
      'sido' : sido,
      'gungu' : gungu,
      'gearType' : gearType.index,
      'fuelType' : fuelType.index,
      'isTuned' : isTuned.index,
      'possibleAS' : possibleAS.index,
      'comment' : comment,
      'imageList': imageList,
      'createdTime' : createdTime
    };
  }
}