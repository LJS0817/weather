import 'dart:convert';
import 'dart:developer';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class Weather {
  //지역 좌표 X와 Y
  final int _nX = 61;
  final int _nY = 120;

  //초단기예보조회를 사용했기에
  //조회하는 것에 따라서 바꾸면 된다.
  final String type = "getUltraSrtFcst";

  //인증키를 넣는 곳
  final String _key = "인증키";

  //초기화 [의미 없음]
  String date = "20231030";
  String time = "1630";

  //최소한으로 데이터를 불러와야하기 때문에 했지만
  //type에 따라서 바꿀 필요가 있다.
  final int dataCount = 36;

  ///TMP
  ///```
  ///기온
  String temp = "";

  String get Temp => "${temp} °C";

  ///SKY
  ///```
  ///하늘 상태
  String sky = "";

  ///REH
  ///```
  ///습도 %
  String moist = "";
  String get Moist => "${moist} %";

  ///RN1
  ///```
  ///강수량
  String rain = "";

  ///PTY
  ///```
  ///강수 형태
  String rainType = "";

  String get Rain => "${rain} mm";

  //카테고리에 따라서 바꾸면 된다.
  void setDataWithType(String type, String data) {
    switch(type) {
      case "T1H":
      case "TMP":
        temp = data;
        break;
      case "SKY":
        sky = getSky(data);
        break;
      case "REH":
        moist = data;
        break;
      case "RN1":
      case "PCP":
        rain = getRainMM(data);
        break;
      case "PTY":
        rainType = getRain(data);
        break;
      default:
        break;
    }
  }

  @override
  String toString() {
    return "기온 : $temp`C\n하늘 상태 : $sky\n습도 : $moist%\n강수량 : $rain\n강수 형태 : $rainType";
  }

  //하늘 상태
  String getSky(String str) {
    if(str == "1") {
      return "맑음";
    } else if(str == "3") {
      return "구름 많음";
    }
    else {
      return "흐림";
    }
  }

  //강수 형태
  String getRain(String str) {
    switch(str) {
      case "0": return "";
      case '1': return '비';
      case '2': return "비/눈";
      case "3": return "눈";
      case "5": return "빗방울";
      case "6": return "빗방울/눈날림";
      case "7": return "눈날림";
      default: return "";
    }
  }

  //강수량에 단위만 붙여서 넘겨준다.
  String getRainMM(String str) {
    double d = double.parse((str == "강수없음" || str == "null" ? 0 : str).toString());
    return d.toString();
  }

  //데이터를 파싱하는 함수
  void setData(Map<String, dynamic> data) {
    // log(data.toString());
    final List<dynamic> d = data["response"]["body"]["items"]["item"];
    //i += 6은 데이터의 형태에 따라서 바꿔야 한다.
    for(int i = 0; i < d.length; i += 6) {
      setDataWithType(d[i]["category"], d[i]["fcstValue"]);
      log(d[i].toString());
    }
    // log(toString());
  }

  //type에 따라서 날짜 계산하는 게 다르기 때문에
  //계산식만 바꿔주면 된다.
  void setDate() {
    DateTime dateTime = DateTime.now();
    DateTime result = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour - (dateTime.minute < 45 ? 1 : 0), 30, 0);
    date = result.toString().split(' ')[0].replaceAll('-', '');
    time = "${result.hour < 10 ? "0${result.hour}" : result.hour}30";
  }


  //api에 요청하는 함수
  Future<bool> get(int c, int lC) async {
    if(c < lC) return false;
    setDate();
    final uri =  Uri.parse("http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/$type?serviceKey=$_key&numOfRows=$dataCount&pageNo=1&base_date=$date&base_time=$time&nx=$_nX&ny=$_nY");

    final response = await http.get(
      uri,
      headers: <String, String> {
        'Content-Type' : 'application/json; charset=UTF-8',
      },
    );
    final json = Xml2Json()..parse(response.body);
    setData(jsonDecode(json.toParker()));
    return true;
  }
}