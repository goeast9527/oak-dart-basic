/// 支持 json 序列化的对象
/// 继承该类的对象必须实现一个静态方法
/// static T formJson(String json)
abstract class JsonSerializableObject {

  //  static  formJson(String json){}

  Map<String, dynamic> toMap() {
    throw new UnsupportedError("method toMap, sub class need override");
  }

  String toJson() {
    throw new UnsupportedError("method toJson, sub class need override");
  }
}
