
class SKJsonConvert<T> {

  static fromJsonSingle<M>(String mtype, json) {
    String type = mtype;
    if (null != M && M is SKJsonConvert) {
      type = M.toString();
    }
    return null;
  }
}