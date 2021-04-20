import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elastic_client/elastic_client.dart' as elastic;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xbike/src/model/elastic_query.dart';
import 'package:xbike/src/model/sales_item.dart';

class LoadSalesItemController extends GetxController {
  static LoadSalesItemController get to => Get.find();

  List<SalesItem> salesItemList = [];

  // firestore DB reference
  CollectionReference ref = FirebaseFirestore.instance.collection('salesItem');

  // need to sort
  List<String> sortingOptions = ['최근등록순','금액낮은순','거리순','주행거리 낮은순','최근연식순'];
  List<String> sortingOptionQuery = ['createdTime', 'amount', 'place', 'milage', 'birthYear'];
  List<bool> sortingQueryDesc= [true, false, false, false, true];
  RxInt sortIndex = 0.obs;

  // need to pagenation
  ScrollController scrollController = ScrollController();
  DocumentSnapshot lastDocument; // flag for last document from where next 10 records to be fetched
  int documentLimit = 4; // documents to be fetched per request
  bool hasMore = true;
  int documentOffset = 0;

  // need to search
  RxList<bool> displacementSwitch = [false, false, false].obs;
  Rx<RangeValues> amountRange = RangeValues(0,2500).obs;
  Rx<RangeValues> milageRange = RangeValues(0,130000).obs;
  RangeValues adjuntAmountRange = RangeValues(0,7000);
  RxString amountText = ''.obs;
  RxString milageText = ''.obs;
  RxList<String> companyModel = RxList([]);
  List<String> companyFilter = [];
  List<String> modelFilter = [];
  Map<double, double> amountTransMap= {2100:3000,
    2200:4000,
    2300:5000,
    2400:6000,
    2500:7000
  };
  Map<String, dynamic> esQueryMap;
  Map<String, dynamic> defaultEsQueryMap;
  String esQueryString = '{ "match_all": {} }';

  @override
  void onInit() {
    _salesItemLoad();
    _event();
    super.onInit();
  }

  _event() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print('reload');
        _salesItemLoad();
      }
    });
  }

  void setSortIndex(int index) {
    this.sortIndex.value = index;
    salesItemList.clear();
    lastDocument = null;
    hasMore = true;
    _salesItemLoad();
  }

  void setMilageText(RangeValues value) {
    final formatter = NumberFormat('#,###');

    if(value.start == 0 && value.end==130000)
      milageText.value = '전체';
    else if(value.start==0 && value.end<130000)
      milageText.value = formatter.format(value.end.toInt()) + 'km 이하';
    else if(value.start>0 && value.end==130000)
      milageText.value = formatter.format(value.start.toInt()) + 'km 이상';
    else
      milageText.value = formatter.format(value.start.toInt()) + 'km ~ '
          + formatter.format(value.end.toInt()) + 'km';
  }



  void adjustAmountText(RangeValues value) {
    final formatter = NumberFormat('#,###');

    if(value.start > 2000){
      adjuntAmountRange = RangeValues(amountTransMap[value.start], amountTransMap[value.end]);
    }
    else if(value.start <= 2000 && value.end > 2000) {
      adjuntAmountRange = RangeValues(value.start, amountTransMap[value.end]);
    }
    else
      adjuntAmountRange= value;

    if(value.start == 0 && value.end==2500)
      amountText.value = '전체';
    else if(value.start==0 && value.end<2500) {
      amountText.value = formatter.format(adjuntAmountRange.end.toInt()) + '만원 이하';
    }
    else if(value.start>0 && value.end==2500)
      amountText.value = formatter.format(adjuntAmountRange.start.toInt()) + '만원 이상';
    else
      amountText.value = formatter.format(adjuntAmountRange.start.toInt()) + '만원 ~ '
          + formatter.format(adjuntAmountRange.end.toInt()) + '만원';
  }

  String makeElasticQuery(){
    ElasticsearchQuery myquery = new ElasticsearchQuery();
    print(myquery.elasticsearchQueryBool);
    String displacementQuery = '';
    String milageQuery = '';
    String amountQuery = '';
    String companyModelQuery = '';


    // displacement(배기량 query 세팅)
    if(displacementSwitch[0] == true) {
      if(displacementSwitch[1] == true) {
        if(displacementSwitch[2] == true) {
          // 모든 배기량 검색이므로 range 지정 없음
          print('displacement range : all');
          displacementQuery = null;
        }
        else if(displacementSwitch[2] == false) {
          // 500cc이하
          var lte = 500;
          displacementQuery = '{"range": {"displacement": {"lte": $lte}}}';
        }
      }
      else if(displacementSwitch[1] == false) {
        if(displacementSwitch[2] == true) {
          // 125cc이하 & 500cc 이상
          var gte = 500;
          var lte = 125;
          displacementQuery = '{"range": {"displacement": {"get": $gte, "lte": $lte}}}';
        }
        else if(displacementSwitch[2] == false) {
          // 125cc이상
          var gte = 125;
          displacementQuery = '{"range": {"displacement": {"get": $gte}}}';
        }
      }
    }
    else if(displacementSwitch[0] == false) {
      if(displacementSwitch[1] == true) {
        if(displacementSwitch[2] == true) {
          // 125cc 이상
          var gte = 125;
          displacementQuery = '{"range": {"displacement": {"gte": $gte}}}';
        }
        else if(displacementSwitch[2] == false) {
          // 125cc이하 & 500cc 이상
          var gte = 125;
          var lte = 500;
          displacementQuery = '{"range": {"displacement": {"get": $gte, "lte": $lte}}}';
        }
      }
      else if(displacementSwitch[1] == false) {
        if(displacementSwitch[2] == true) {
          // 500cc 이상
          var gte = 500;
          displacementQuery = '{"range": {"displacement": {"get": $gte}}}';
        }
      }
    }

    // amount (금액 범위 query 세팅)
    if(adjuntAmountRange.start == 0 && adjuntAmountRange.end==7000) {
      print('amount range value : all');
    }
    else if(adjuntAmountRange.start==0 && adjuntAmountRange.end<7000) {
      var lte = adjuntAmountRange.end.toInt();
      amountQuery = '{"range": {"amount": {"lte": $lte}}}';
    }
    else if(adjuntAmountRange.start>0 && adjuntAmountRange.end==7000) {
      var gte = adjuntAmountRange.start.toInt();
      amountQuery = '{"range": {"amount": {"gte": $gte}}}';
    }
    else {
      var lte = adjuntAmountRange.end.toInt();
      var gte = adjuntAmountRange.start.toInt();
      amountQuery = '{"range": {"amount": {"gte": $gte, "lte": $lte}}}';
    }

    // milage (주행거리 query 세팅)
    if(milageRange.value.start == 0 && milageRange.value.end==130000) {
      print('milage range value : all');
    }
    else if(milageRange.value.start==0 && milageRange.value.end<130000) {
      var lte = milageRange.value.end.toInt();
      milageQuery = '{"range": {"milage": {"lte": $lte}}}';
    }
    else if(milageRange.value.start>0 && milageRange.value.end==130000) {
      var gte = milageRange.value.start.toInt();
      milageQuery = '{"range": {"milage": {"gte": $gte}}}';
    }
    else {
      var lte = milageRange.value.end.toInt();
      var gte = milageRange.value.start.toInt();
      milageQuery = '{"range": {"milage": {"gte": $gte, "lte": $lte}}}';
    }

    // 제조사 / 모델 multi_match query
    for(int i = 0 ; i< companyModel.length ; i++){
      String t = companyModel[i];
      companyModelQuery += '{"multi_match": {"query": "$t", "fields": ["company", "model"]}}';
      if(i != companyModel.length-1)
        companyModelQuery += ',';
    }

    String startWith = '{"bool": {"filter": [';
    esQueryString += startWith;

    bool beforeQuery = false;
    if((displacementQuery==null || displacementQuery.length == 0) &&
        (amountQuery==null || amountQuery.length == 0) &&
        (milageQuery==null || milageQuery.length == 0) &&
        (companyModelQuery==null || companyModelQuery.length==0)) {
      esQueryMap = defaultEsQueryMap;
      return esQueryString;
    }
    else {
      esQueryString = '';
      String startWith = '{"bool": {"filter": [';
      esQueryString += startWith;
      if(displacementQuery != null && displacementQuery.length != 0) {
        esQueryString += displacementQuery;
        beforeQuery = true;
      }
      if(amountQuery != null && amountQuery.length != 0) {
        if(beforeQuery == true)
          esQueryString += ',';
        else
          beforeQuery = true;
        esQueryString += amountQuery;
      }
      if(milageQuery != null && milageQuery.length != 0) {
        if (beforeQuery == true)
          esQueryString += ',';
        else
          beforeQuery = true;
        esQueryString += milageQuery;
      }
      if(companyModelQuery != null && companyModelQuery.length != 0) {
        if (beforeQuery == true)
          esQueryString += ',';
        else
          beforeQuery = true;
        esQueryString += companyModelQuery;
      }
    }
    String endClause = ']}}';
    esQueryString += endClause;

    salesItemList.clear();
    lastDocument = null;
    hasMore = true;
    _salesItemLoad();
    //esQueryMap = json.decode(esQueryString);

    print(esQueryString);
    print(esQueryMap);
    return esQueryString;
  }

  Future _salesItemLoad() async{
    /*
    if(salesItemList.length == 0) {
      print("sales item length 0");
    }
    if(!hasMore){
      print('no more bike items');
      return;
    }
    QuerySnapshot querySnapshot;

    if(lastDocument == null) {
       querySnapshot = await ref.orderBy(sortingOptionQuery[sortIndex.value], descending: sortingQueryDesc[sortIndex.value])
           .limit(documentLimit).get();
    }
    else {
       querySnapshot = await ref.orderBy(sortingOptionQuery[sortIndex.value], descending: sortingQueryDesc[sortIndex.value])
           .startAfterDocument(lastDocument).limit(documentLimit).get();
    }

    if(querySnapshot.docs.length < documentLimit){
      hasMore = false;
    }

    print(querySnapshot.docs[0]);

    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];

    querySnapshot.docs.forEach((doc) {
      var mapJson = Map<String,dynamic>.from(doc.data());
      print(doc.id);
      mapJson.addAll({'key' : doc.id});
      print('file: loadSalesItem : ${doc["company"]}');
      salesItemList.add(
          SalesItem.fromJson(mapJson)); // Deserialization step #3
    });
     */

    String username = 'elastic';
    String password = '2NgJkJLPvlEsOlEezQSVDKwU';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final transport = elastic.HttpTransport(url: "https://xbike-search-deployment.es.us-west1.gcp.cloud.es.io:9243",
        authorization: basicAuth);
    final client = elastic.Client(transport);
    var rs1;

     //String queryString = makeElasticQuery();
     Map myQuery = json.decode(esQueryString);

    if(!hasMore){
      print('no more bike items');
      return;
    }
    else {
      rs1 = await client.search(
          index: 'sales_item',
          type: '_doc',
          query: myQuery,
          source: true,
          limit: documentLimit,
          offset: documentOffset,
          sort: [
            { sortingOptionQuery[sortIndex.value]: 'desc'},
          ]
      );
    }

    documentOffset += documentLimit;
    if(rs1.hits.length < documentLimit)
      hasMore = false;

    print( 'hits length = ${rs1.hits.length}, document offset = $documentOffset' );

     print(rs1.toMap());
    // print(rs1.hits[0].doc);
    // print("!!!elasticsearch test!!!");
    // print(rs1.hits[1].doc);

    rs1.hits.forEach((doc) {
      var mapJson = Map<String,dynamic>.from(doc.doc);
      print(doc.id);
      mapJson.addAll({'key' : doc.id});
      print('file: loadSalesItem : ${doc.doc["company"]}');
      salesItemList.add(
          SalesItem.fromJson(mapJson)); // Deserialization step #3
    });



    print("loadSalesItem");
    update();

    return;
  }
}