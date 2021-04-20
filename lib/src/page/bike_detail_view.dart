import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xbike/src/controller/page_index_controller.dart';
import 'package:xbike/src/model/sales_item.dart';

class BikeDetailView extends StatelessWidget {
  BikeDetailView({Key key}) : super(key: key);

  final SalesItem selecteditem = Get.arguments;

  //var birthYear = e.birthYear;
/*
  Widget _imageSlider() {
    List<String> sliderImage = selecteditem.imageList;
    return Container();
  }
*/

  Widget _imageSlider() {
    Get.put(PageIndexController());
    return GestureDetector(
      onTap: () {
        Get.toNamed('/view/detail/photos', arguments: selecteditem.imageList);
      },
      child: Stack(
        children: [
          CarouselSlider(
            items: selecteditem.imageList.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  print(MediaQuery.of(context).size.width);
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      //margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5)
                      ),
                      child: CachedNetworkImage(
                        imageUrl: i,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
                initialPage: Get.find<PageIndexController>().index.value,
                autoPlay: false,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                aspectRatio: 1.2,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  //setState(() {
                    Get.find<PageIndexController>().chageIndex(index);
                  //});
                }
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: selecteditem.imageList.map((url) {
                int index = selecteditem.imageList.indexOf(url);
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(selecteditem.model),),
      body: Column(
        children: [
          _imageSlider(),
        ],
      ),
    );
  }
}