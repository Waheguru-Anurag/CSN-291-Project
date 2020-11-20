import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../globals.dart';

class ImageColorizerResults extends StatefulWidget {
  @override
  ImageColorizerResultsState createState() => ImageColorizerResultsState();
}

class ImageColorizerResultsState extends State<ImageColorizerResults> {
  Image _getImageFromURL(String url) {
    return Image.network(url);
  }

  bool _isImage(String url) {
    if (url != null) {
      if (Image.network(url).height != 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Widget _imageContainer(dynamic image) {
    return Container(
      width: ScreenUtil().setWidth(226),
      height: ScreenUtil().setHeight(270),
      child: FittedBox(
        fit: image is Image ? BoxFit.fitWidth : BoxFit.none,
        alignment: Alignment.center,
        child: image,
      ),
    );
  }

  Widget _noImageContainer() {
    return Container(
      width: ScreenUtil().setWidth(300),
      height: ScreenUtil().setHeight(300),
      color: Theme.of(context).disabledColor.withOpacity(0.3),
      child: Center(
          child: Text(
        'Image not given at Entry!',
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: Theme.of(context).backgroundColor),
      )),
    );
  }

  Future<bool> showToast(String toastMessage) {
    return Fluttertoast.showToast(
        msg: toastMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[500],
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Image Colorizer App',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(24),
              ScreenUtil().setHeight(32),
              ScreenUtil().setWidth(24),
              ScreenUtil().setHeight(18)),
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  var result = await FlutterDownloader.enqueue(
                      url: URL + 'imgs_out/eccv16.jpg',
                      savedDir:
                          await ExtStorage.getExternalStoragePublicDirectory(
                              ExtStorage.DIRECTORY_DOWNLOADS));

                  if (result == null) {
                    showToast("Failed to Download the Image");
                  } else {
                    showToast("Downloaded the Image");
                  }
                },
                child: _isImage(URL + 'imgs_out/eccv16.jpg')
                    ? _imageContainer(
                        _getImageFromURL(URL + 'imgs_out/eccv16.jpg'))
                    : _noImageContainer(),
              ),
              SizedBox(height: ScreenUtil().setHeight(40)),
              GestureDetector(
                onTap: () async {
                  var result = await FlutterDownloader.enqueue(
                      url: URL + 'imgs_out/siggraph17.jpg',
                      savedDir:
                          await ExtStorage.getExternalStoragePublicDirectory(
                              ExtStorage.DIRECTORY_DOWNLOADS));
                  if (result == null) {
                    showToast("Failed to Download the Image");
                  } else {
                    showToast("Downloaded the Image");
                  }
                },
                child: _isImage(URL + 'imgs_out/siggraph17.jpg')
                    ? _imageContainer(
                        _getImageFromURL(URL + 'imgs_out/siggraph17.jpg'))
                    : _noImageContainer(),
              ),
            ],
          ),
        ));
  }
}
