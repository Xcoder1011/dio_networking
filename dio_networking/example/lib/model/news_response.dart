part 'news_response.m.dart';

class NewsResponse {
  SKAuthorModel? author;
  String? msg;
  int? code;
  List<SKDataModel>? data;

  NewsResponse fromJson(Map<String, dynamic> json) =>
      _$NewsResponseFromJson(json, this);
  Map<String, dynamic> toJson() => _$NewsResponseToJson(this);
}

class SKAuthorModel {
  String? desc;
  String? name;
  double? money;

  SKAuthorModel fromJson(Map<String, dynamic> json) =>
      _$SKAuthorModelFromJson(json, this);
  Map<String, dynamic> toJson() => _$SKAuthorModelToJson(this);
}

class SKDataModel {
  String? digest;
  String? title;
  String? docid;
  String? time;
  String? m_url;
  String? imgsrc;
  String? source;
  String? pc_url;

  SKDataModel fromJson(Map<String, dynamic> json) =>
      _$SKDataModelFromJson(json, this);
  Map<String, dynamic> toJson() => _$SKDataModelToJson(this);
}
