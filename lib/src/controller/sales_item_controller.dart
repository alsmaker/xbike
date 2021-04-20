import 'dart:io';

import 'package:get/get.dart';
import 'package:xbike/src/page/register_basic.dart';

class SalesItemController extends GetxController {
  String company;
  String model;
  int displacement;

  String birthYear;
  String milage;
  String amount;

  String sido;
  String gungu;

  GearType gearType;
  FuelType fuelType;
  IsTuned isTuned;
  PossibleAS possibleAS;

  String comment;

  List<File> imageList = new List(10);

  void setModel(String company, String model, int displacement) {
    this.company = company;
    this.model = model;
    this.displacement = displacement;

    update();
  }

  void setRegion(String sido, String gungu) {
    this.sido = sido;
    this.gungu = gungu;

    update();
  }

  void setBirthYear(String birthYear) {
    print('in birthyear controller func + $birthYear');
    this.birthYear = birthYear;

    update();
  }

  void setMilage(String milage) {

    print('in milage controller func + $milage');
    this.milage = milage.replaceAll(',', '');

    update();
  }

  void setAmount(String amount) {
    print('in amout controller func + $amount');
    this.amount = amount.replaceAll(',', '');

    update();
  }

  void setGearType(GearType gearType) {
    print('in gear controller func + $amount');
    this.gearType = gearType;

    update();
  }

  void setFuelType(FuelType fuelType) {
    print('in fuel controller func + $amount');
    this.fuelType = fuelType;

    update();
  }

  void setTunning(IsTuned isTuned) {
    print('in tunning controller func + $amount');
    this.isTuned = isTuned;

    update();
  }

  void setPossibleAS(PossibleAS possibleAS) {
    print('in as controller func + $amount');
    this.possibleAS = possibleAS;

    update();
  }

  void setComment(String comment) {
    this.comment = comment;

    update();
  }

  void addImageList(File imageURL, index) {
    this.imageList[index] = imageURL;

    update();
  }
}