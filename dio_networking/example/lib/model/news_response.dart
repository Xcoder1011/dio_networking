part 'news_response.m.dart';

class NewsResponse {
   int? code;
   List<SKDataModel>? data;
   String? msg;
   SKAuthorModel? author;

   NewsResponse fromJson(Map<String, dynamic> json) => _$NewsResponseFromJson(json, this);
   Map<String, dynamic> toJson() => _$NewsResponseToJson(this);
}

class SKDataModel {
   String? imgsrc;
   String? time;
   String? source;
   String? docid;
   String? m_url;
   String? title;
   String? pc_url;
   String? digest;

   SKDataModel fromJson(Map<String, dynamic> json) => _$SKDataModelFromJson(json, this);
   Map<String, dynamic> toJson() => _$SKDataModelToJson(this);
}

class SKAuthorModel {
   String? desc;
   String? name;
   double? money;

   SKAuthorModel fromJson(Map<String, dynamic> json) => _$SKAuthorModelFromJson(json, this);
   Map<String, dynamic> toJson() => _$SKAuthorModelToJson(this);
}
