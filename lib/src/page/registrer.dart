import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xbike/src/controller/sales_item_controller.dart';
import 'package:xbike/src/model/sales_item.dart';
import 'package:xbike/src/page/register_basic.dart';
import 'package:xbike/src/page/register_picture.dart';

class Register extends StatefulWidget{
  const Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState(){
    super.initState();

    // tabbar controller initialize
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SalesItemController());
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('바이크 등록'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '기본정보'),
            Tab(text: '사진등록',)
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RegisterBasic(),
          RegisterPicture(),
        ],
      ),

      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Get.toNamed('/register/done');
      //   },
      //   icon: Icon(Icons.add, color: Colors.white,),
      //   label: new Text('매물등록'),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: keyboardIsOpened ? null : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
              onPressed: null,
              label: Text('초기화'),
              heroTag : "btn2"
          ),
          SizedBox(width: 30,),
          FloatingActionButton.extended(
          onPressed: () {
              Get.toNamed('/register/done');
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: Text('매물등록'),
            heroTag : "btn1"
          ),

        ],
      ),
    );
  }
}

class UploadItem extends StatefulWidget {
  @override
  _UploadItemState createState() => _UploadItemState();
}

class _UploadItemState extends State<UploadItem> {
  SalesItem salesItem;
  CollectionReference ref = FirebaseFirestore.instance.collection('salesItem');


  @override
  void initState() {
    super.initState();
  }

  Future<List<String>> saveImageList() async {
    final SalesItemController controller = Get.find();
    List<String> imageList = [];

    print('image save start');

    for (var i = 0; i < controller.imageList.length; i++) {
      if (controller.imageList[i] != null) {


        var fileTimeStamp = DateTime
            .now()
            .millisecondsSinceEpoch;
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage
            .instance
            .ref()
            .child('salesItemImage')
            .child(fileTimeStamp.toString()+'.jpg');
        
        firebase_storage.UploadTask uploadTask = ref.putFile(
            controller.imageList[i]);
        String downloadURL;

        await uploadTask.whenComplete(() async {
          try {
            print('get download url');
            downloadURL = await ref.getDownloadURL();
            imageList.add(downloadURL);
            print(downloadURL);
          } catch (onError) {
            print('download url error');
          }
        });
        print('$fileTimeStamp file 등록');
      }
    }
    return imageList;
  }

  Future saveBasicInfo(List<String> imageList) async {
    final SalesItemController controller = Get.find();

    if (controller.company == null || controller.model == null
    // controller.displacement == null ||
    // controller.birthYear == null || controller.milage == null ||
    // controller.amount == null ||
    // controller.sido == null || controller.gungu == null || controller.comment == null
    ) {
      // 모든 필드가 입력이 완료되어야 함
      print('null field');
    }
    else {
      print('firebase database input start');

      ref.add(SalesItem(
          company: controller.company,
          model: controller.model,
          displacement: controller.displacement,
          birthYear: int.parse(controller.birthYear),
          milage: int.parse(controller.milage),
          amount: int.parse(controller.amount),
          sido: controller.sido,
          gungu: controller.gungu,
          gearType: controller.gearType,
          fuelType: controller.fuelType,
          isTuned: controller.isTuned,
          possibleAS: controller.possibleAS,
          comment: controller.comment,
          imageList: imageList,
          createdTime: DateTime.now().toIso8601String())
          .toJson());
    }
    print('print register done!!!');
    return 'regist done!!';
  }

  Future<dynamic> saveSalesItem() async {
    final SalesItemController controller = Get.find();
    List<String> imageList;

    print(controller.company);
    print(controller.model);
    print(controller.displacement);

    imageList = await saveImageList();
    print('between image and info');
    String result = await saveBasicInfo(imageList);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
            child: FutureBuilder<dynamic>(
              future: saveSalesItem(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                print('builder called');

                if(snapshot.hasError)
                  print(snapshot.hasError);

                if(snapshot.hasData) {
                      return AlertDialog(
                        title: Text("등록이 완료되었습니다"),
                        content: Text("등록이 완료되었습니다"),
                        actions: <Widget>[
                          new FlatButton(
                              onPressed: () {
                                Get.offAllNamed('/');
                              },
                              child: new Text('확인')),
                        ],
                      );
                  //return Text('register done !!!');
                }
                  return CircularProgressIndicator();
              },
            ),
          ),
    );
  }
}