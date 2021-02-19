
class SKJsonConvert<T> {

  static fromJsonSingle<M>(String mtype, json) {
    String type = mtype;
    if (null != M && M is SKJsonConvert) {
      type = M.toString();
    }
    return SKJsonConvert().sk_fromJsonSingle(type, json);
  }

  // SKJsonConvert sk_fromJsonSingle<M>(String mtype, json) {
  //   String type = mtype;
  //   if (null != M && M is SKJsonConvert) {
  //     type = M.toString();
  //   }
  //   return SKJsonConvert();
  // }

  SKJsonConvert sk_fromJsonSingle<M>(String type, json) {
    if (null != M && M is SKJsonConvert) {
      type = M.toString();
    }
    print("SKJsonConvert sk_fromJsonSingle");
    return SKJsonConvert();
  }

}

