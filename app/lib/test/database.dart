class Data {
  String geekName;
  int userId;

  String get geek_name {
    return geekName;
  }

  set geek_name(String name) {
    this.geekName = name;
  }

  int get user_id {
    return userId;
  }

  set user_id(int id) {
    this.userId = id;
  }
  /* Future<int> test(int a) async{
    await Future.delayed(Duration(seconds: 1));
    Map params = Map();
    await(http.post("${Config.API_URL}/user_profile/login",body: params).then((res) {
      Map resMap = jsonDecode (res.body) as Map;
      int _data = resMap["data"];
      userId = resMap["getId"];
    }));
  }*/
} /*
Future<Data> fetctData() async{
  Map params = Map();
  final res = await http.post('${Config.API_URL}/user_profile/login',body: params).then((res) {
    Map resMap = jsonDecode (res.body) as Map;
    int _data = resMap["data"];
    var userId = resMap["getId"];
  });
  return Data.fromJson(json.decode(res.body));
}
class Data{
  final int userId;
  Data({this.userId});

  factory Data.fromJson(Map<String,dynamic> json){
    return Data(
      userId: json['userId'],
    );
  }

}
*/
