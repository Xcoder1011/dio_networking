
class SKJsonConvert<T> {

  static fromJsonSingle<M>(String modelType, json) {
    String type = modelType;
    if (M is SKJsonConvert) {
      type = M.toString();
    }
    return SKJsonConvert().skFromJsonSingle(type, json);
  }

  SKJsonConvert skFromJsonSingle(String modelType, json) {
    // TODO:
    return json;
  }
}
