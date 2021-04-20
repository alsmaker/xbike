import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:xbike/src/component/item_list_widget.dart';
import 'package:xbike/src/controller/load_sales_item_controller.dart';
import 'package:xbike/src/model/bike_model.dart';
import 'package:xbike/src/page/register_basic.dart';

class BikeListView extends StatefulWidget {
  BikeListView({Key key}) : super(key: key);

  @override
  _BikeListViewState createState() => _BikeListViewState();
}

class _BikeListViewState extends State<BikeListView> {
  final LoadSalesItemController controller = Get.put(LoadSalesItemController());

  Future<String> _selectSort() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState2) {
              return AlertDialog(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                content: Container(
                  width: double.minPositive,
                  height: 285,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.sortingOptions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Obx(() => RadioListTile(
                            value: index,
                            groupValue: controller.sortIndex.value,
                            //_currentIndex,
                            title: Text(controller.sortingOptions[index]),
                            onChanged: (val) {
                              Get.find<LoadSalesItemController>()
                                  .setSortIndex(index);
                              Get.back();
                            },
                          ));
                    },
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            SliverAppBar(
              title: Container(
                child: Row(
                  children: [
                    Expanded(child: Text("매물보기")),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/view/filter', arguments: controller);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Container(
                          width: 18,
                          height: 18,
                          child: SvgPicture.asset('assets/icons/filter1.svg',
                              color: Colors.white),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectSort();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Container(
                          width: 18,
                          height: 18,
                          child: SvgPicture.asset(
                            "assets/icons/sort.svg",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              floating: true,
              snap: true,
            ),
            GetBuilder<LoadSalesItemController>(builder: (controller) {
              print('list getbuilder');
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/view/detail',
                          arguments: controller.salesItemList[index]);
                    },
                    child: (controller == null ||
                            controller.salesItemList.length == 0)
                        ? null
                        : ItemListWidget(
                            salesItem: controller.salesItemList[index]),
                  );
                },
                    childCount: (controller == null ||
                            controller.salesItemList.length == 0)
                        ? 0
                        : controller.salesItemList.length),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {

  LoadSalesItemController loadSalesItemController = Get.arguments;

  @override
  void initState() {
    super.initState();

    loadSalesItemController.setMilageText(loadSalesItemController.milageRange.value);
    loadSalesItemController.adjustAmountText(loadSalesItemController.amountRange.value);
  }

  Widget chipCompnayModelButton(String value) {
    return Container(
      width: 110,
      padding: EdgeInsets.all(0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Colors.grey, // set border color
            width: 1.2), // set border width
        borderRadius: BorderRadius.all(
            Radius.circular(30.0)), // set rounded corner radius
      ),
      child: Text(value,
          style: TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(LoadSalesItemController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // paddingSymmetric(horizontal: 30),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  '배기량',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(()=>GestureDetector(
                  onTap: () {
                    if(loadSalesItemController.displacementSwitch[0])
                      loadSalesItemController.displacementSwitch[0] = false;
                    else
                      loadSalesItemController.displacementSwitch[0] = true;
                  },
                  child: Container(
                    width: 110,
                    //margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(7),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Get.find<LoadSalesItemController>().displacementSwitch[0]
                              ? Colors.blue : Colors.grey, // set border color
                          width: 1.2), // set border width
                      borderRadius: BorderRadius.all(
                          Radius.circular(30.0)), // set rounded corner radius
                      //boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))]// make rounded corner of border
                    ),
                    child: Text("125cc이하",
                        style: TextStyle(color: Get.find<LoadSalesItemController>().displacementSwitch[0]
                            ? Colors.blue : Colors.grey, fontSize: 12)),
                  ),
                ),),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      if (loadSalesItemController.displacementSwitch[1])
                        loadSalesItemController.displacementSwitch[1] = false;
                      else
                        loadSalesItemController.displacementSwitch[1] = true;
                    },
                    child: Container(
                      width: 110,
                      //margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(7),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Get.find<LoadSalesItemController>().displacementSwitch[1]
                                ? Colors.blue : Colors.grey, // set border color
                            width: 1.2), // set border width
                        borderRadius: BorderRadius.all(
                            Radius.circular(30.0)), // set rounded corner radius
                        //boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))]// make rounded corner of border
                      ),
                      child: Text(
                        "500cc이하",
                        style: TextStyle(color: Get.find<LoadSalesItemController>().displacementSwitch[1]
                            ? Colors.blue : Colors.grey, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                  Obx(
                  () => GestureDetector(
                    onTap: () {
                      if (loadSalesItemController.displacementSwitch[2])
                        loadSalesItemController.displacementSwitch[2] = false;
                      else
                        loadSalesItemController.displacementSwitch[2] = true;
                    },
                    child: Container(
                      width: 110,
                      //margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(7),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Get.find<LoadSalesItemController>().displacementSwitch[2]
                                ? Colors.blue : Colors.grey, // set border color
                            width: 1.2), // set border width
                        borderRadius: BorderRadius.all(
                            Radius.circular(30.0)), // set rounded corner radius
                        //boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))]// make rounded corner of border
                      ),
                      child: Text(
                        "500cc이상",
                        style: TextStyle(color: Get.find<LoadSalesItemController>().displacementSwitch[2]
                            ? Colors.blue : Colors.grey, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  '금액',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                )),
            Container(
              height: 17.0,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Obx(()=>Text(loadSalesItemController.amountText.value,
                style: TextStyle(fontSize: 12, color: Colors.black),
              )),
            ),
            Obx(()=>RangeSlider(
                divisions: 25,
                activeColor: Colors.blue,
                inactiveColor: Colors.blue[100],
                min: 0,
                max: 2500,
                values: loadSalesItemController.amountRange.value,
                onChanged: (value) {
                  loadSalesItemController.amountRange.value = value;
                  loadSalesItemController.adjustAmountText(value);
                }),
            ),

            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                '주행거리',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              //color: Colors.white,
            ),
            Container(
              height: 17.0,
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Obx(()=>Text(loadSalesItemController.milageText.value,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                )),
            ),
            Obx(()=>RangeSlider(
                divisions: 13,
                activeColor: Colors.blue,
                inactiveColor: Colors.blue[100],
                min: 0,
                max: 130000,
                values: loadSalesItemController.milageRange.value,
                onChanged: (value) {
                  loadSalesItemController.milageRange.value = value;
                  loadSalesItemController.setMilageText(value);
                }),
      ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                if( (loadSalesItemController.companyModel.length) < 5)
                  Get.toNamed('/view/filter/company', arguments: loadSalesItemController);
                else
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text('5개까지 선택가능'),
                          content: Text("선택된 모델을 삭제후 시도해 주세요"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.pop(context, "OK");
                              },
                            ),
                          ]);
                    },
                  );
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  '제조사/모델',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                //color: Colors.white,
              ),
            ),
            Obx(()=>Container(
              alignment: Alignment.centerLeft,
              height: 30,
              child: ListView.builder(
                itemCount: loadSalesItemController.companyModel.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      loadSalesItemController.companyModel.remove(loadSalesItemController.companyModel[index]);
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0,0,8,0),
                      padding: EdgeInsets.symmetric(horizontal: 11.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.grey, // set border color
                            width: 1.2), // set border width
                        borderRadius: BorderRadius.all(
                            Radius.circular(30.0)), // set rounded corner radius
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 14,
                          ),
                          SizedBox(width: 5),
                          Text(loadSalesItemController.companyModel[index],
                              style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.horizontal,
              ),
            ),),
          ],
        ),
      ),
      floatingActionButton:
      FloatingActionButton.extended(
          onPressed: (){
            loadSalesItemController.makeElasticQuery();
            //Get.until((route) => Get.currentRoute == '/view/filter');
            Get.back();
          },
          label: Text('검색')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class FilterCompanyList extends StatelessWidget {
  final LoadSalesItemController controller = Get.arguments;

  Future<List<CompanyModel>> loadJson() async {
    print('load json func()');
    String jsonString =
        await rootBundle.loadString('assets/json/modelspec.json');
    print('loadjson \n' + jsonString);

    return compute(parseModelSpec, jsonString);
  }

  Widget companyListView(List<CompanyModel> company) {
    print(company.length);
    return ListView.separated(
      itemCount: company.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(company[index].company),
          onTap: () {
            Get.to(FilterModelList(
                company: company[index].company,
                model: company[index].modelSpec,
              controller: controller,
            ));
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

            if (snapshot.hasData) {
              print(snapshot.data);
              final List<CompanyModel> company = snapshot.data;
              return companyListView(company);
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class FilterModelList extends StatelessWidget {
  final String company;
  final List<ModelSpec> model;
  final LoadSalesItemController controller;

  FilterModelList({Key key, @required this.company, @required this.model, @required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("모델명선택"),
      ),
      body: ListView.separated(
        itemCount: model.length,
        itemBuilder: (contetxt, int index) {
          return ListTile(
            title: Text(model[index].name),
            onTap: () {
              //controller.companyModel.add(model[index].name, "model");
              controller.companyModel.add(model[index].name);
              Get.until((route) => Get.currentRoute == '/view/filter');
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
      floatingActionButton:
          FloatingActionButton.extended(
              onPressed: (){
                controller.companyModel.add(company);
                Get.until((route) => Get.currentRoute == '/view/filter');
              },
              label: Text(company+' 전체선택')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
