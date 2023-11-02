import 'dart:async';
import 'dart:developer' as Log;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:weather/portrait.dart';
import 'package:weather/weather.dart';
import 'package:wakelock/wakelock.dart';

final Weather weather = Weather();

///밤이 되면 색을 바꾸려고 한다.
get background => weather.isNight ? Color(0xFF0F2542) : Color(0xFFb4dae6);
get textColor => weather.isNight ? Color(0xFFD5E39E) : Color(0xFF387F96);


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


///```
///0 - left
///1 - top
///2 - right
///3 - begin
///4 - end
final List<List<double?>> position = [
];

///구름 배열
final List<Widget> clouds = [
];

///구름 이미지 랜덤으로 가져오기
String getCloudImage(int idx) {
  return 'assets/icon/cloud_$idx.png';
}

///구름을 그려주는 함수
Widget Cloud(List<double?> pos, int index) {

  return Visibility(
    visible: weather.getSkytoInt() <= index,
    child: Positioned(
      left: pos[0],
      top: pos[1],
      right: pos[2],
      child: AnimatedOpacity(
          duration: const Duration(milliseconds: 240),
          opacity: 1,
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(getCloudImage(pos[5]!.toInt()), fit: BoxFit.fitHeight, color: Colors.white.withOpacity(0.85),),
          )
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).slideX(curve: Curves.linear, begin: pos[3], end: pos[4], duration: 5500.ms),
  );
}

///하늘 상태에 따라서 구름의 개수를 계산한다.
void calculateCloud() {
  clouds.clear();
  position.clear();
  for(int i = 0; i < weather.getSkytoInt(); i++) {
    position.add(
        [
          i % 2 == 0 ? (5 * (i * 2)).toDouble() : null,
          (55 + Random().nextInt(10)).toDouble(),
          i % 2 == 1 ? (5 * (i * 2)).toDouble() : null,
          Random().nextDouble(),
          Random().nextDouble(),
          Random().nextInt(3).toDouble(),
        ]
    );
    Log.log(position[i].toString());
    clouds.add(Cloud(position[i], weather.getSkytoInt()));
  }
}

class Home extends StatefulWidget {
  Home({super.key});

  //화면 업데이트를 위한 타이머
  late Timer timer;

  //현재 시간
  DateTime date = DateTime.now();

  //타이머가 10분이 되면 날씨를 한번 업데이트한다.
  static const int limitCount = 600;

  //처음 업데이트를 위한 초기화
  int count = limitCount - 1;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // calculateCloud();

    Wakelock.enable();

    //1초마다 카운트 한다.
    widget.timer =  Timer.periodic(
        const Duration(seconds: 1),
        (Timer t) {
          setState(() {
            widget.count++;
            widget.date = DateTime.now();
          });
        }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          color: background,
          child: FutureBuilder(
              //밤인지 계산하고 카운트 초기화를 여기서 해준다.
              future: weather.get(widget.count, Home.limitCount).then((value) => {
                widget.count = widget.count >= Home.limitCount ? 0 : widget.count,
                weather.isNight = (widget.date.hour > 20 || widget.date.hour < 6) && !weather.isNight}
              ),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Stack(
                  children: [
                    Positioned(
                        top: 45,
                        left: 135,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: const Color(0x13F8FFAA),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        )
                    ),
                    Positioned(
                        top: 60,
                        left: 150,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: const Color(0x5AF8FFAA),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        )
                    ),
                    Positioned(
                        top: 75,
                        left: 165,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FFAA),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        )
                    ),
                    Stack(
                      children: clouds,
                    ),
                    Positioned(
                      child: WaveWidget(
                        config: CustomConfig(
                          colors: const [ Color(0xCFFFFFFF), Color(0xB3FFFFFF), Color(0xA3FFFFFF),],
                          durations: [8000, 10000, 12000],
                          heightPercentages: [0.54, 0.56, 0.58],
                        ),
                        size: const Size(double.maxFinite, double.maxFinite),
                      ),
                    ),
                    Positioned(
                      left: 150,
                      bottom: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${int.parse(weather.temp)}°",
                            style: TextStyle(
                              color: weather.isNight ? background : textColor,
                              fontSize: 65,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 20,
                        right: 50,
                        child: Portrait(widget.date)
                    ),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 앱이 꺼지기 전에 타이머를 꺼준다.
    widget.timer.cancel();

    Wakelock.disable();
    super.dispose();
  }
}
