import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xbike/src/controller/sales_item_controller.dart';
import 'package:xbike/src/model/bike_model.dart';
import 'package:flutter/services.dart' show TextInputFormatter, rootBundle;
import 'package:xbike/src/model/sigungu.dart';

class RegisterBasic extends StatefulWidget{
  const RegisterBasic({Key key}) : super(key: key);

  @override
  _RegisterBasicState createState() => _RegisterBasicState();
}

enum GearType { auto, manual }
enum FuelType { gasoline, electric }
enum IsTuned { nope, yes }
enum PossibleAS { impossible, possible }

class _RegisterBasicState extends State<RegisterBasic> {
  final double heightOfEachColumn = 50;

  final _yearContorller = TextEditingController();
  final _milageController = TextEditingController();
  final _salesAmount = TextEditingController();
  final _commentController = TextEditingController();

  GearType _gearType = GearType.auto;
  FuelType _fuelType = FuelType.gasoline;
  IsTuned _isTuned = IsTuned.nope;
  PossibleAS _possibleAS = PossibleAS.impossible;

  List<String> gearTypeText = ["자동", "수동"];
  List<String> fuelTypeText = ["가솔린", "전기"];
  List<String> isTunedText = ["없음", "있음"];
  List<String> possibleASText = ["불가능", "가능"];

  @override
  void initState()  {
    super.initState();
    print('register basic init state called');


    // _commentController.text = "▶차량설명\n-사고유무 : \n-관리상태 : \n-외관상태 : \n-튜닝정보 : \n\n"
    //     "▶차주정보\n-구입방법 : \n-판매이유 : \n-운행용도 : \n\n"
    //     "▶문의방법";
    _commentController.text = "ing...";


    // textfield 사용 아이템 controller 연결
    _yearContorller.addListener(checkBirthYear);
    _milageController.addListener(() {
      Get.find<SalesItemController>().setMilage(_milageController.text);
    });
    _salesAmount.addListener(() {
      Get.find<SalesItemController>().setAmount(_salesAmount.text);
    });
    _commentController.addListener(() {
      Get.find<SalesItemController>().setComment(_commentController.text);
    });
    Get.find<SalesItemController>().setComment(_commentController.text);

    Get.find<SalesItemController>().setGearType(_gearType);
    Get.find<SalesItemController>().setFuelType(_fuelType);
    Get.find<SalesItemController>().setTunning(_isTuned);
    Get.find<SalesItemController>().setPossibleAS(_possibleAS);
  }

  void checkBirthYear() {
    Get.find<SalesItemController>().setBirthYear(_yearContorller.text);
  }

  Widget model() {
    return GestureDetector(
      onTap: () {
        Get.toNamed("/register/company");
      },
      child : GetBuilder<SalesItemController>(
        builder: (controller) {
          if(controller.model != null)
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              //height: heightOfEachColumn,
              child: Column(
                children: [
                  Container(
                    height: heightOfEachColumn,
                    child: Row(
                    children: [
                      makeTitle('제조사'),
                      Expanded(
                        child: Text('${controller.company}'),
                      ),
                    ],
                  ),
                  ),
                  registerPageDivider(),
                  Container(
                    height: heightOfEachColumn,
                    child: Row(
                    children: [
                      makeTitle('모델'),
                      Expanded(
                        child: Text('${controller.model}'),
                      ),
                    ],
                  ),
                  ),
                  registerPageDivider(),
                  Container(
                    height: heightOfEachColumn,
                    //color: Colors.grey,
                    child: Row(
                    children: [
                      makeTitle('배기량'),
                      Expanded(
                        child: Text('${controller.displacement.toString()}'),
                      ),
                      Text('cc'),
                    ],
                  ),
                  ),
                ],
              ),
            );
          else
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: heightOfEachColumn,
                // color: Colors.amber,
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 35,
                      //color: Colors.amber,
                      child: Center(
                        child: Text('제조사/모델')//, style: TextStyle(backgroundColor: Colors.blueGrey)),
                      ),

                    ),

                    Expanded(
                      child: Text(''),
                    ),
                    Text('>'),// style: TextStyle(backgroundColor: Colors.blueAccent),),
                  ],
                ),
              );
        },
      ),
    );
  }

  Widget makeTitle(String title) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 35,
          child: Center(
            child: Text(
                title), // style: TextStyle(backgroundColor: Colors.blueGrey)),
          ),
        ),
        Container(
          width: 15,
          height: 35,
          // color: Colors.amber,
          child: Center(
            child: Text(
                '|'), // style: TextStyle(backgroundColor: Colors.blueGrey)),
          ),
        ),
        Container(
          width: 20,
        ),
      ],
    );
  }

  Widget birthYear() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: heightOfEachColumn,
      child: Row(
        children: [
          makeTitle('연식'),
          Expanded(
            child: TextField(
              controller: _yearContorller,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
              //showCursor: false,
            ),
          ),
          Text('년'),
        ],
      ),
    );
  }

  Widget milage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: heightOfEachColumn,
      child: Row(
        children: [
          makeTitle('주행거리'),
          Expanded(
            child: TextField(
              controller: _milageController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
              //showCursor: false,
              inputFormatters: [
                CurrencyInputFormatter()
              ],
            ),
          ),
          Text('Km'),
        ],
      ),
    );
  }

  Widget salesAmout() {
     return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: heightOfEachColumn,
      child: Row(
        children: [
        makeTitle('판매금액'),
          Expanded(
            child: TextField(
              controller: _salesAmount,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
              //showCursor: false,
              inputFormatters: [
                CurrencyInputFormatter()
              ],
            ),
          ),
          Text('만원'),
        ],
      ),
    );
  }

  Widget region() {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/register/sido');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: heightOfEachColumn,
        // color: Colors.amber,
        child: Row(
          children: [
          makeTitle('판매지역'),
          GetBuilder<SalesItemController>(
              builder: (controller) {
                if(controller.gungu != null)
                  return Expanded(
                    child: Text('${controller.sido}'+' '+'${controller.gungu}'),
                  );
                else
                  return Expanded(
                  child: Text(''),
                );
              }
              ),
            Text('>'),// style: TextStyle(backgroundColor: Colors.blueAccent),),
          ],
        ),
      ),
    );
  }

  Widget gearType() {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              print(GearType.values[0]);
              return AlertDialog(
                title: Text('변속기 선택'),
                content: Container(
                  width: double.minPositive,
                  height: 115,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: gearTypeText.length,
                    itemBuilder: (BuildContext context, int index){
                      print(gearTypeText.length);
                      return RadioListTile<GearType> (
                          value: GearType.values[index],
                          groupValue: _gearType,
                          title: Text(gearTypeText[index]),
                          onChanged: (GearType value) {
                            _gearType = value;
                            Get.find<SalesItemController>().setGearType(_gearType);
                            Get.back();
                          });
                    },
                  ),
                ),
              );
            }
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: heightOfEachColumn,
        // color: Colors.amber,
        child: Row(
          children: [
            makeTitle('변속기'),
            GetBuilder<SalesItemController>(builder: (controller) {
              return Expanded(
                child: Text(gearTypeText[_gearType.index]),
              );
            }),
            Text('>'),
          ],
        ),
      ),
    );
  }

  Widget fuelType() {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              print(FuelType.values[0]);
              return AlertDialog(
                title: Text('연료종류 선택'),
                content: Container(
                  width: double.minPositive,
                  height: 115,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: fuelTypeText.length,
                    itemBuilder: (BuildContext context, int index){
                      print(fuelTypeText.length);
                      return RadioListTile<FuelType> (
                          value: FuelType.values[index],
                          groupValue: _fuelType,
                          title: Text(fuelTypeText[index]),
                          onChanged: (FuelType value) {
                            _fuelType = value;
                            Get.find<SalesItemController>().setFuelType(_fuelType);
                            Get.back();
                          });
                    },
                  ),
                ),
              );
            }
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: heightOfEachColumn,
        // color: Colors.amber,
        child: Row(
          children: [
            makeTitle('연료'),
            GetBuilder<SalesItemController>(builder: (controller) {
              return Expanded(
                child: Text(fuelTypeText[controller.fuelType.index]),
              );
            }),
            Text('>'),// style: TextStyle(backgroundColor: Colors.blueAccent),),
          ],
        ),
      ),
    );
  }

  Widget isTuned() {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              print(IsTuned.values[0]);
              return AlertDialog(
                title: Text('튜닝여부 선택'),
                content: Container(
                  width: double.minPositive,
                  height: 115,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: isTunedText.length,
                    itemBuilder: (BuildContext context, int index){
                      print(isTunedText.length);
                      return RadioListTile<IsTuned> (
                          value: IsTuned.values[index],
                          groupValue: _isTuned,
                          title: Text(isTunedText[index]),
                          onChanged: (IsTuned value) {
                            _isTuned = value;
                            Get.find<SalesItemController>().setTunning(_isTuned);
                            Get.back();
                          });
                    },
                  ),
                ),
              );
            }
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: heightOfEachColumn,
        // color: Colors.amber,
        child: Row(
          children: [
            makeTitle('튜닝여부'),
            GetBuilder<SalesItemController>(builder: (controller) {
              return Expanded(
                child: Text(isTunedText[controller.isTuned.index]),
              );
            }),
            Text('>'),// style: TextStyle(backgroundColor: Colors.blueAccent),),
          ],
        ),
      ),
    );
  }

  Widget possibleAS() {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              print(PossibleAS.values[0]);
              return AlertDialog(
                title: Text('A/S 선택'),
                content: Container(
                  width: double.minPositive,
                  height: 115,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: possibleASText.length,
                    itemBuilder: (BuildContext context, int index){
                      print(possibleASText.length);
                      return RadioListTile<PossibleAS> (
                          value: PossibleAS.values[index],
                          groupValue: _possibleAS,
                          title: Text(possibleASText[index]),
                          onChanged: (PossibleAS value) {
                            _possibleAS = value;
                            Get.find<SalesItemController>().setPossibleAS(_possibleAS);
                            Get.back();
                          });
                    },
                  ),
                ),
              );
            }
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: heightOfEachColumn,
        child: Row(
          children: [
            makeTitle('A/S'),
            GetBuilder<SalesItemController>(builder: (controller){
              return Expanded(
                child: Text(possibleASText[_possibleAS.index]),
              );
            }),
            Text('>'),// style: TextStyle(backgroundColor: Colors.blueAccent),),
          ],
        ),
      ),
    );
  }

  Widget comment() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text("상세설명"),
          SizedBox(
            height: 15,
          ),
          TextField(
            controller: _commentController,
            minLines: 11,
            maxLines: 30,

            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(1.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget registerPageDivider() {
    return Divider(
      indent: 5,
      endIndent: 5,
      height: 0,
      thickness: 0.5,
      color: Colors.grey,
    );
  }

  void showAlertDialog(String title, List<String> tileTextList) async{
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Container(
              width: double.minPositive,
              height: 115,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tileTextList.length,
                itemBuilder: (BuildContext context, int index){
                  print(tileTextList.length);
                  return RadioListTile(
                      value: index,
                      groupValue: index,
                      title: Text(tileTextList[index]),
                      onChanged: null);
                },
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ListBody(
          // Column(
          children: [
            model(),
            registerPageDivider(),
            birthYear(),
            registerPageDivider(),
            milage(),
            registerPageDivider(),
            salesAmout(),
            registerPageDivider(),
            region(),
            registerPageDivider(),
            gearType(),
            registerPageDivider(),
            fuelType(),
            registerPageDivider(),
            isTuned(),
            registerPageDivider(),
            possibleAS(),
            registerPageDivider(),
            SizedBox(
              height: 20,
            ),
            comment(),
            SizedBox(
              height: 80,
            ),
            //uploadPictures(),
          ],
        ),
      ),
    );
  }
}

List<CompanyModel> parseModelSpec(String companyJson) {
  final parsed = json.decode(companyJson).cast<Map<String, dynamic>>();
  return parsed.map<CompanyModel>((json) => CompanyModel.fromJson(json)).toList();
}

class CompanyList extends StatelessWidget {
  Future<List<CompanyModel>> loadJson() async{
    print('load json func()');
    String jsonString = await rootBundle.loadString('assets/json/modelspec.json');
    print('loadjson \n'+jsonString);

    return compute(parseModelSpec, jsonString);
  }
  
  Widget companyListView(List<CompanyModel> company) {
    print(company.length);
    return ListView.separated(
        itemCount: company.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(company[index].company),
            onTap: () {
              Get.to(ModelList(company: company[index].company ,model: company[index].modelSpec));
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('제조사'),
      ),
      body: Center(
        child: FutureBuilder<List<CompanyModel>>(
          future: loadJson(),
          builder: (context, snapshot) {
            //print(snapshot.data);
            if (snapshot.hasError) print(snapshot.error);

            if(snapshot.hasData) {
              print(snapshot.data);
              final List<CompanyModel> company = snapshot.data;
              return companyListView(company);
            }
            else
              return Center(child: CircularProgressIndicator());
            },
        ),
      ),
    );
  }
}

class ModelList extends StatelessWidget {
  final String company;
  final List<ModelSpec> model;

  ModelList({Key key, @required this.company, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("모델명선택"),
      ),
      body: ListView.builder(
          itemCount: model.length,
          itemBuilder: (contetxt, int index){
            return ListTile(
            title: Text(model[index].name),
              onTap: () {
              Get.to(DisplacementSelect(company : company, model: model[index].name, displacement: model[index].displacement));
              },
            );
            },
      ),
    );

  }
}

class DisplacementSelect extends StatelessWidget {
  final String company;
  final String model;
  final int displacement;

  DisplacementSelect({Key key, @required this.company, @required this.model, @required this.displacement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("배기량선택"),
      ),
      body: ListView.builder(
        itemCount: 1,  // todo : need to chanme List
        itemBuilder: (contetxt, int index){
          return ListTile(
            title: Text(displacement.toString()+'cc'),
            onTap: () {
              Get.find<SalesItemController>().setModel(company, model, displacement);
              Get.until((route) => Get.currentRoute == '/register');
            },
          );

        },
      ),
    );
  }
}

List<Sigungu> parseSigungu(String sigunguJson) {
  final parsed = json.decode(sigunguJson).cast<Map<String, dynamic>>();
  return parsed.map<Sigungu>((json) => Sigungu.fromJson(json)).toList();
}

class SidoList extends StatelessWidget {

  Future<List<Sigungu>> loadSigungu() async{
    String jsonString = await rootBundle.loadString('assets/json/sigungu.json');
    return compute(parseSigungu, jsonString);
    //return parseSigungu(jsonString);
  }

  Widget sidoListView(List<Sigungu> sigungu) {
    print(sigungu.length);
    return ListView.builder(
      itemCount: sigungu.length,
      itemBuilder: (BuildContext context, int index){
        return ListTile(
          title: Text(sigungu[index].sido),
          onTap: () {
            Get.to(GunguList(sido: sigungu[index].sido, gungu: sigungu[index].gungu));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('시도선택'),
      ),
      body: Center(
        child: FutureBuilder<List<Sigungu>>(
        future: loadSigungu(),
            builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          if(snapshot.hasData) {
            final List<Sigungu> sigungu = snapshot.data;
            return sidoListView(sigungu);
          }
          else
            return Center(child: CircularProgressIndicator());
        }
        ),
      ),
    );
  }
}

class GunguList extends StatelessWidget {
  final String sido;
  final List<String> gungu;

  GunguList({Key key, @required this.sido, @required this.gungu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("군구 선택"),
      ),
      body: ListView.builder(
        itemCount: gungu.length,  // todo : need to chanme List
        itemBuilder: (contetxt, int index){
          return ListTile(
            title: Text(gungu[index]),
            onTap: () {
              Get.find<SalesItemController>().setRegion(sido, gungu[index]);
              Get.until((route) => Get.currentRoute == '/register');
            },
          );
        },
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {

  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    if(newValue.selection.baseOffset == 0){
      print(newValue.selection.baseOffset);
      return newValue.copyWith(text: '');
    } else if(newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;
      final formatter = NumberFormat('#,###');
      int value = int.parse(newValue.text.replaceAll(formatter.symbols.GROUP_SEP, ''));
      String newText = formatter.format(value);

      return newValue.copyWith(
          text: newText,
          selection: new TextSelection.collapsed(offset: newText.length-selectionIndexFromTheRight));
    } else {
      return newValue;
    }
  }
}