import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_colorizer_app/model/image_colorizer_model.dart';

import '../globals.dart';
import 'dart:convert';

class ImageColorizerService {
  var dio = Dio(BaseOptions(
    connectTimeout: 60000,
    receiveTimeout: 60000,
  ));

  Future postData(Map<String, dynamic> postMap) async {
    var image = ImageColorizerModel(
      file: postMap['image'] != null
          ? await MultipartFile.fromFile(await postMap['image'])
          : null,
    );

    FormData formData = await new FormData.fromMap(image.toJson());
    var uri = URL + 'imgs';

    try {
      var response = await dio.post(uri, data: formData);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        print('Timeout Error!!');
        return false;
      } else if (e.type == DioErrorType.CANCEL) {
        print('Cancel Error!!');
        return false;
      } else if (e.type == DioErrorType.DEFAULT) {
        print('Default Error!!');
        return false;
      } else if (e.type == DioErrorType.RESPONSE) {
        print('Response Error!!');
        return false;
      }
    } on Exception catch (e) {
      print('EXCEPTION CAUGHT!!');
      print(e);
      return false;
    }
  }
}
