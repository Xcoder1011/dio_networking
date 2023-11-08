part of 'news_response.dart';

NewsResponse _$NewsResponseFromJson(
    Map<String, dynamic> json, NewsResponse instance) {
  if (json['author'] != null) {
    instance.author = SKAuthorModel().fromJson(json['author']);
  }
  if (json['msg'] != null) {
    instance.msg = json['msg']?.toString();
  }
  if (json['code'] != null) {
    final code = json['code'];
    if (code is String) {
      instance.code = int.parse(code);
    } else {
      instance.code = code?.toInt();
    }
  }
  if (json['data'] != null) {
    instance.data = <SKDataModel>[];
    for (var v in (json['data'] as List)) {
      instance.data?.add(SKDataModel().fromJson(v));
    }
  }
  return instance;
}

Map<String, dynamic> _$NewsResponseToJson(NewsResponse instance) {
  final Map<String, dynamic> json = <String, dynamic>{};
  json['author'] = instance.author?.toJson();
  json['msg'] = instance.msg;
  json['code'] = instance.code;
  json['data'] = instance.data?.map((v) => v.toJson()).toList();
  return json;
}

SKAuthorModel _$SKAuthorModelFromJson(
    Map<String, dynamic> json, SKAuthorModel instance) {
  if (json['desc'] != null) {
    instance.desc = json['desc']?.toString();
  }
  if (json['name'] != null) {
    instance.name = json['name']?.toString();
  }
  if (json['money'] != null) {
    final money = json['money'];
    if (money is String) {
      instance.money = double.parse(money);
    } else {
      instance.money = money?.toDouble();
    }
  }
  return instance;
}

Map<String, dynamic> _$SKAuthorModelToJson(SKAuthorModel instance) {
  final Map<String, dynamic> json = <String, dynamic>{};
  json['desc'] = instance.desc;
  json['name'] = instance.name;
  json['money'] = instance.money;
  return json;
}

SKDataModel _$SKDataModelFromJson(
    Map<String, dynamic> json, SKDataModel instance) {
  if (json['digest'] != null) {
    instance.digest = json['digest']?.toString();
  }
  if (json['title'] != null) {
    instance.title = json['title']?.toString();
  }
  if (json['docid'] != null) {
    instance.docid = json['docid']?.toString();
  }
  if (json['time'] != null) {
    instance.time = json['time']?.toString();
  }
  if (json['m_url'] != null) {
    instance.m_url = json['m_url']?.toString();
  }
  if (json['imgsrc'] != null) {
    instance.imgsrc = json['imgsrc']?.toString();
  }
  if (json['source'] != null) {
    instance.source = json['source']?.toString();
  }
  if (json['pc_url'] != null) {
    instance.pc_url = json['pc_url']?.toString();
  }
  return instance;
}

Map<String, dynamic> _$SKDataModelToJson(SKDataModel instance) {
  final Map<String, dynamic> json = <String, dynamic>{};
  json['digest'] = instance.digest;
  json['title'] = instance.title;
  json['docid'] = instance.docid;
  json['time'] = instance.time;
  json['m_url'] = instance.m_url;
  json['imgsrc'] = instance.imgsrc;
  json['source'] = instance.source;
  json['pc_url'] = instance.pc_url;
  return json;
}
