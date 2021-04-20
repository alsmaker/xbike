import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:xbike/src/page/bike_detail_view.dart';
import 'package:xbike/src/page/bike_list_view.dart';
import 'package:xbike/src/page/bike_photo_view.dart';
import 'package:xbike/src/page/login.dart';
import 'package:xbike/src/page/register_basic.dart';
import 'src/page/home.dart';
import 'src/page/registrer.dart';
import 'src/page/register_basic.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => Home()),
        GetPage(name: '/register', page: () => Register()),
        GetPage(name: '/register/company', page: ()=> CompanyList()),
        GetPage(name: '/register/model', page: ()=> ModelList(company: '',model: [],)),
        GetPage(name: '/register/sido', page: ()=> SidoList()),
        GetPage(name: '/register/done', page: ()=> UploadItem()),
        GetPage(name: '/view', page: ()=> BikeListView()),
        GetPage(name: '/view/filter', page: ()=> Filter()),
        GetPage(name: '/view/filter/company', page: ()=> FilterCompanyList()),
        GetPage(name: '/view/detail', page: ()=> BikeDetailView()),
        GetPage(name: '/view/detail/photos', page: ()=> BikePhotoView()),
        GetPage(name: '/login', page: ()=> LoginPage())
      ]
    );
  }
}
