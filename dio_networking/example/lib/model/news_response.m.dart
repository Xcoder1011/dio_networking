//
//  news_response.m.dart
//  SKGenerateModelTool
//
//  Created by wushangkun on 2021/01/28.
//  Copyright © 2021 SKGenerateModelTool. All rights reserved.
//

part of 'news_response.dart';


NewsResponse _$NewsResponseFromJson(Map<String, dynamic> json, NewsResponse instance) {
  if (json['data'] != null) {
    instance.data = new List<SKDataModel>();
    (json['data'] as List).forEach((v) {
      instance.data.add(new SKDataModel().fromJson(v));
    });
  }
  if (json['msg'] != null) {
    instance.msg = json['msg']?.toString();
  }
  if (json['author'] != null) {
    instance.author = new SKAuthorModel().fromJson(json['author']);
  }
  if (json['code'] != null) {
    instance.code = json['code']?.toInt();
  }
  return instance;
}

Map<String, dynamic> _$NewsResponseToJson(NewsResponse instance) {
  final Map<String, dynamic> json = new Map<String, dynamic>();
  if (instance.data != null) {
    json['data'] = instance.data.map((v) => v.toJson()).toList();
  }
  json['msg'] = instance.msg;
  if (instance.author != null) {
    json['author'] = instance.author.toJson();
  }
  json['code'] = instance.code;
  return json;
}

SKDataModel _$SKDataModelFromJson(Map<String, dynamic> json, SKDataModel instance) {
  if (json['source'] != null) {
    instance.source = json['source']?.toString();
  }
  if (json['title'] != null) {
    instance.title = json['title']?.toString();
  }
  if (json['m_url'] != null) {
    instance.m_url = json['m_url']?.toString();
  }
  if (json['imgsrc'] != null) {
    instance.imgsrc = json['imgsrc']?.toString();
  }
  if (json['time'] != null) {
    instance.time = json['time']?.toString();
  }
  if (json['pc_url'] != null) {
    instance.pc_url = json['pc_url']?.toString();
  }
  if (json['docid'] != null) {
    instance.docid = json['docid']?.toString();
  }
  if (json['digest'] != null) {
    instance.digest = json['digest']?.toString();
  }
  return instance;
}

Map<String, dynamic> _$SKDataModelToJson(SKDataModel instance) {
  final Map<String, dynamic> json = new Map<String, dynamic>();
  json['source'] = instance.source;
  json['title'] = instance.title;
  json['m_url'] = instance.m_url;
  json['imgsrc'] = instance.imgsrc;
  json['time'] = instance.time;
  json['pc_url'] = instance.pc_url;
  json['docid'] = instance.docid;
  json['digest'] = instance.digest;
  return json;
}

SKAuthorModel _$SKAuthorModelFromJson(Map<String, dynamic> json, SKAuthorModel instance) {
  if (json['name'] != null) {
    instance.name = json['name']?.toString();
  }
  if (json['desc'] != null) {
    instance.desc = json['desc']?.toString();
  }
  return instance;
}

Map<String, dynamic> _$SKAuthorModelToJson(SKAuthorModel instance) {
  final Map<String, dynamic> json = new Map<String, dynamic>();
  json['name'] = instance.name;
  json['desc'] = instance.desc;
  return json;
}
