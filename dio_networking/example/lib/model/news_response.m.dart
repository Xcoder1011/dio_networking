//
//  news_response.m.dart
//  SKGenerateModelTool
//
//  Created by wushangkun on 2021/01/29.
//  Copyright © 2021 SKGenerateModelTool. All rights reserved.
//

part of 'news_response.dart';

NewsResponse _$NewsResponseFromJson(Map<String, dynamic> json, NewsResponse instance) {
  if(json['msg'] != null) {
    instance.msg = json['msg']?.toString();
  }
  if(json['data'] != null) {
    instance.data = new List<SKDataModel>();
    (json['data'] as List).forEach((v) {
      instance.data.add(new SKDataModel().fromJson(v));
    });
  }
  if(json['author'] != null) {
    instance.author = new SKAuthorModel().fromJson(json['author']);
  }
  if(json['code'] != null) {
    final code = json['code'];
    if(code is String) {
      instance.code = int.parse(code);
    } else {
      instance.code = code?.toInt();
    }
  }
  return instance;
}

Map<String, dynamic> _$NewsResponseToJson(NewsResponse instance) {
  final Map<String, dynamic> json = new Map<String, dynamic>();
  json['msg'] = instance.msg;
  if(instance.data != null) {
    json['data'] = instance.data.map((v) => v.toJson()).toList();
  }
  if(instance.author != null) {
    json['author'] = instance.author.toJson();
  }
  json['code'] = instance.code;
  return json;
}

SKDataModel _$SKDataModelFromJson(Map<String, dynamic> json, SKDataModel instance) {
  if(json['docid'] != null) {
    instance.docid = json['docid']?.toString();
  }
  if(json['source'] != null) {
    instance.source = json['source']?.toString();
  }
  if(json['pc_url'] != null) {
    instance.pc_url = json['pc_url']?.toString();
  }
  if(json['imgsrc'] != null) {
    instance.imgsrc = json['imgsrc']?.toString();
  }
  if(json['time'] != null) {
    instance.time = json['time']?.toString();
  }
  if(json['digest'] != null) {
    instance.digest = json['digest']?.toString();
  }
  if(json['m_url'] != null) {
    instance.m_url = json['m_url']?.toString();
  }
  if(json['title'] != null) {
    instance.title = json['title']?.toString();
  }
  return instance;
}

Map<String, dynamic> _$SKDataModelToJson(SKDataModel instance) {
  final Map<String, dynamic> json = new Map<String, dynamic>();
  json['docid'] = instance.docid;
  json['source'] = instance.source;
  json['pc_url'] = instance.pc_url;
  json['imgsrc'] = instance.imgsrc;
  json['time'] = instance.time;
  json['digest'] = instance.digest;
  json['m_url'] = instance.m_url;
  json['title'] = instance.title;
  return json;
}

SKAuthorModel _$SKAuthorModelFromJson(Map<String, dynamic> json, SKAuthorModel instance) {
  if(json['name'] != null) {
    instance.name = json['name']?.toString();
  }
  if(json['money'] != null) {
    final money = json['money'];
    if(money is String) {
      instance.money = double.parse(money);
    } else {
      instance.money = money?.toDouble();
    }
  }
  if(json['desc'] != null) {
    instance.desc = json['desc']?.toString();
  }
  return instance;
}

Map<String, dynamic> _$SKAuthorModelToJson(SKAuthorModel instance) {
  final Map<String, dynamic> json = new Map<String, dynamic>();
  json['name'] = instance.name;
  json['money'] = instance.money;
  json['desc'] = instance.desc;
  return json;
}
