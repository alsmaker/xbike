import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'package:xbike/src/controller/sales_item_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class RegisterPicture extends StatefulWidget {
  const RegisterPicture({Key key}) : super(key: key);

  @override
  _RegisterPictureState createState() => _RegisterPictureState();
}

class _RegisterPictureState extends State<RegisterPicture> {
  // File _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future getImage(int index) async {
    var width, height;
    print('getImage select');
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if(pickedFile == null)
      return;

    //final tempDir = await path_provider.getTemporaryDirectory();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = path.join(tempDir.path, path.basenameWithoutExtension(pickedFile.path)+'temp'+path.extension(pickedFile.path));
    //String tempPath = path.join(tempDir.path, 'test.jpg');
    File tempImage;

    print('picked file path = ${pickedFile.path}');
    print('temporary image file path = $tempPath');

    var decodedImage = await img.decodeImage(File(pickedFile.path).readAsBytesSync());

    if(Platform.isAndroid) {
      width = decodedImage.width;
      height = decodedImage.height;
    } else {
      // todo : ios implement
    }
    print('selected image with = $width & height = $height');

    if(width<640 || height<640){
      tempImage = await _compressImage(File(pickedFile.path), tempPath, width, height);
    }
    else if(width < height) {
      var ratio2 = (width/height).toStringAsFixed(3);
      var newValue2 = 640*double.parse(ratio2);
      int newWidth = newValue2.toInt();
      int newHeight = 640;

      tempImage = await _compressImage(File(pickedFile.path), tempPath, newWidth, newHeight);

    } else if(height < width) {
      var ratio2 = (height/width).toStringAsFixed(3);
      var newValue2 = 640*double.parse(ratio2);
      int newWidth = 640;
      int newHeight = newValue2.toInt();

      tempImage = await _compressImage(File(pickedFile.path), tempPath, newWidth, newHeight);

    } else {
      var newWidth = 640;
      var newHeight = 640;

      tempImage = await _compressImage(File(pickedFile.path), tempPath, newWidth, newHeight);
    }

    //Get.find<SalesItemController>().addImageList(File(pickedFile.path), index);
    Get.find<SalesItemController>().addImageList(tempImage, index);
  }

  Future<File> _compressImage(File file, String targetPath, width, height) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 88,
        minWidth: width,
        minHeight: height
    );

    //단위 바이트 확률 높음
    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  Widget showImage(File image) {
    return Container(
      child: Image.file(image, fit: BoxFit.cover,)
    );
  }

  Widget uploadPictures() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
              alignment: Alignment.centerLeft,
              child: Text('사진을 등록해주세요'),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(15),
              shrinkWrap: true, // Vertical viewport was given unbounded height 문제 해결),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
              childAspectRatio: 1 / 1,
            ),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  getImage(index);
                  print('test');
                },
                child: GetBuilder<SalesItemController>(builder: (controller) {
                  //print(controller.imageList[index].path);
                  return Container(
                    padding: EdgeInsets.all(0),
                    child: controller.imageList[index] == null
                        ? Icon(Icons.add_a_photo)
                        : showImage(File(controller.imageList[index].path)),
                    color: Colors.grey,
                  );
                }),
              );
            },
            ),
          ),
    SizedBox(
    height: 60,),
        ]
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: uploadPictures(),
    );
  }
}
