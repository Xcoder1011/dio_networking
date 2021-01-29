//
//  news_response.dart
//  SKGenerateModelTool
//
//  Created by wushangkun on 2021/01/29.
//  Copyright © 2021 SKGenerateModelTool. All rights reserved.
//

part 'news_response.m.dart';

class NewsResponse {
   String msg;  // success
   List<SKDataModel> data;
   SKAuthorModel author;
   int code;  // 200

   NewsResponse fromJson(Map<String, dynamic> json) => _$NewsResponseFromJson(json, this);
   Map<String, dynamic> toJson() => _$NewsResponseToJson(this);
}

class SKDataModel {
   String docid;
   String source;  // 券商中国
   String pc_url;
   String imgsrc;
   String time;
   String digest;
   String m_url;
   String title;

   SKDataModel fromJson(Map<String, dynamic> json) => _$SKDataModelFromJson(json, this);
   Map<String, dynamic> toJson() => _$SKDataModelToJson(this);
}

class SKAuthorModel {
   String name;
   double money;  // 56.8
   String desc;

   SKAuthorModel fromJson(Map<String, dynamic> json) => _$SKAuthorModelFromJson(json, this);
   Map<String, dynamic> toJson() => _$SKAuthorModelToJson(this);
}
