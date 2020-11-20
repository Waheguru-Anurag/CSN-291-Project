// To parse this JSON data, do
//
//     final imageColorizerModel = imageColorizerModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ImageColorizerModel imageColorizerModelFromJson(String file) =>
    ImageColorizerModel.fromJson(json.decode(file));

String imageColorizerModelToJson(ImageColorizerModel data) =>
    json.encode(data.toJson());

class ImageColorizerModel {
  ImageColorizerModel({
    @required this.file,
  });

  dynamic file;

  factory ImageColorizerModel.fromJson(Map<String, dynamic> json) =>
      ImageColorizerModel(
        file: json["file"] == null ? null : json["file"],
      );

  Map<String, dynamic> toJson() => {
        "file": file == null ? null : file,
      };
}
