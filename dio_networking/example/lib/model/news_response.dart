//
//  news_response.dart
//  SKGenerateModelTool
//
//  Created by wushangkun on 2021/01/28.
//  Copyright © 2021 SKGenerateModelTool. All rights reserved.
//

part 'news_response.m.dart';


class NewsResponse {

    List<SKDataModel> data;
    String msg;  // success
    SKAuthorModel author;
    int code;  // 200

    NewsResponse fromJson(Map<String, dynamic> json) => _$NewsResponseFromJson(json, this);
    Map<String, dynamic> toJson() => _$NewsResponseToJson(this);
}

class SKDataModel {

    String source;  // 市界
    String title;
    String m_url;
    String imgsrc;
    String time;
    String pc_url;
    String docid;
    String digest;

    SKDataModel fromJson(Map<String, dynamic> json) => _$SKDataModelFromJson(json, this);
    Map<String, dynamic> toJson() => _$SKDataModelToJson(this);
}

class SKAuthorModel {

    String name;  // Alone88
    String desc;

    SKAuthorModel fromJson(Map<String, dynamic> json) => _$SKAuthorModelFromJson(json, this);
    Map<String, dynamic> toJson() => _$SKAuthorModelToJson(this);
}
