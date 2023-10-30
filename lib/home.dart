import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

final Weather weather = Weather();
final Color background = Color(0xFF3C4D62);
final Color textColor = Color(0xFFA9BEC5);


class Home extends StatefulWidget {
  Home({super.key});

  //화면 업데이트를 위한 타이머
  late Timer timer;

  //현재 시간
  DateTime date = DateTime.now();

  //타이머가 10분이 되면 날씨를 한번 업데이트한다.
  static const int limitCount = 3600;

  //처음 업데이트를 위한 초기화
  int count = limitCount;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    //1초마다 카운트 한다.
    widget.timer =  Timer.periodic(
        const Duration(seconds: 1),
        (Timer t) {
          setState(() {
            widget.count++;
            if(widget.count >= Home.limitCount) {
              widget.count = 0;
            }
            widget.date = DateTime.now();
          });
        }
    );
    super.initState();
  }

  //시간 아래 나오는 박스
  Widget TextIconBox(String title, String data) {
    return Container(
      width: 110,
      height: 85,
      decoration: BoxDecoration(
        color: textColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: background,
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 5)),
          Container(
            height: 40,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: background,
            ),
            alignment: Alignment.center,
            child: Text(
              data,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.bold
              ),
            ),
          ),

        ],
      ),
    );
  }

  //요일을 넘겨준다.
  String getWeekday(int i) {
    switch(i) {
      case 1: return "월요일";
      case 2: return "화요일";
      case 3: return "수요일";
      case 4: return "목요일";
      case 5: return "금요일";
      case 6: return "토요일";
      case 7: return "일요일";
      default: return "월요일";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        body: FutureBuilder(
            future: weather.get(widget.count, Home.limitCount),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child:  Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //20시부터 6시까지는 달 그림이 나온다.
                          Image.asset(widget.date.hour > 19 || widget.date.hour < 7 ? 'assets/icon/night.png' : 'assets/icon/sun.png', width: 200, height: 200, color: textColor,),
                          const Padding(padding: EdgeInsets.only(bottom: 40)),
                          Container(
                            width: 100,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: textColor,
                            ),
                            child: Text(
                              weather.Temp,
                              style: TextStyle(
                                color: background,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            //날짜와 요일, 강수 형태를 보여준다.
                            "${widget.date.year} - ${widget.date.month} - ${widget.date.day}\n[ ${getWeekday(widget.date.weekday)} ]  ${weather.rainType}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: textColor,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 10)),
                          Text(
                            //10시(분, 초) 이전에는 숫자 앞에 0을 붙여 01, 02, 03, ... 처럼 보이게 한다.
                            "${widget.date.hour < 10 ? "0${widget.date.hour}" : widget.date.hour} : ${widget.date.minute < 10 ? "0${widget.date.minute}" : widget.date.minute} : ${widget.date.second < 10 ? "0${widget.date.second}" : widget.date.second}",
                            style: TextStyle(
                              fontSize: 75,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 40)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextIconBox("하늘 상태", weather.sky),
                              const Padding(padding: EdgeInsets.only(right: 30)),
                              TextIconBox("습도", weather.Moist),
                              const Padding(padding: EdgeInsets.only(right: 30)),
                              TextIconBox("강수", weather.Rain),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              );
            }
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 앱이 꺼지기 전에 타이머를 꺼준다.
    widget.timer.cancel();
    super.dispose();
  }
}
