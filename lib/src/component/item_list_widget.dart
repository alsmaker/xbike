import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:xbike/src/model/sales_item.dart';

class ItemListWidget extends StatelessWidget {
  final SalesItem salesItem;
  const ItemListWidget({Key key, this.salesItem}) : super(key: key);

  Widget _thumnail() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
          //height: 280,
          child: CachedNetworkImage(
            imageUrl: salesItem.imageList[0],
            placeholder: (context, url) => Container(
              //height: 230,
              child: Center(child: CircularProgressIndicator()),
            ),
              fit: BoxFit.cover
          ),
        ),
          // (salesItem.imageList == null || salesItem.imageList.length == 0) ? CircularProgressIndicator() :
          // Image.network(salesItem.imageList[0], fit: BoxFit.cover,),
      ),
    );
  }

  Widget _detailInfo() {
    final formatter = NumberFormat('#,###');
    return Container(
      decoration: BoxDecoration(),
      padding: EdgeInsets.fromLTRB(13, 2, 13, 23),
      child: Container(
        // decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8)),
        // border: Border.),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(salesItem.company+' '+salesItem.model, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,color: Colors.black),),
                  Text(salesItem.birthYear.toString()+'년 · '+ formatter.format(salesItem.milage)+'km · '+salesItem.sido+' '+salesItem.gungu, style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.8))),
                ],
              ),
            ),
            //Expanded(child: null),
            Container(
              child: Text(formatter.format(salesItem.amount)+'만원', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _thumnail(),
          _detailInfo(),
        ],
      ),
    );
  }
}