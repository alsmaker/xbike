import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xbike/src/controller/page_index_controller.dart';

class BikePhotoView extends StatelessWidget {
  BikePhotoView({Key key}) : super(key: key);
  final List<String> photoList = Get.arguments;


  @override
  Widget build(BuildContext context) {
    Get.put(PageIndexController());
    return Column(
      children: [
        CarouselSlider(
          items: photoList.map((i) {
            return Builder(
              builder: (BuildContext context) {
                print(MediaQuery.of(context).size.width);
                return Container(
                  width: MediaQuery.of(context).size.width,
                  //margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                      //color: Colors.grey.withOpacity(0.5)
                    color: Colors.black
                  ),
                  child: CachedNetworkImage(
                    imageUrl: i,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    fit: BoxFit.fitWidth,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
              initialPage: Get.find<PageIndexController>().index.value,
              height: MediaQuery.of(context).size.height-40,
              autoPlay: false,
              enlargeCenterPage: false,
              //aspectRatio: 1.2,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                //setState(() {
                Get.find<PageIndexController>().chageIndex(index);
                //});
              }
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: photoList.map((url) {
              int index = photoList.indexOf(url);
              return Obx(()=>Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Get.find<PageIndexController>().index.value == index
                      ? Color.fromRGBO(255, 255, 255, 0.8)
                      : Color.fromRGBO(80, 80, 80, 0.6),
                ),
              ));
            }).toList(),
          ),
        ),
      ],
    );
  }
}