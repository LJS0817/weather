import 'package:flutter/material.dart';
import 'package:weather/home.dart';

class Portrait extends StatelessWidget {
  late DateTime date;

  Portrait(DateTime time, {super.key}) {
    date = time;
  }

  //시간 계산을 해준다.
  Widget timeBox(int t) {
    return Container(
      width: 100,
      alignment: Alignment.center,
      child: Text(
        "${t < 10 ? "0$t" : t}",
        style: TextStyle(
          fontSize: 75,
          color: textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                timeBox(date.hour),
                SizedBox(width: 24, child: Text(":", textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 45, fontWeight: FontWeight.bold),),),
                timeBox(date.minute),
                SizedBox(width: 24, child: Text(":", textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 45, fontWeight: FontWeight.bold),),),
                timeBox(date.second),
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            Text(
              //날짜와 요일, 강수 형태를 보여준다.
              "${date.year} - ${date.month} - ${date.day < 10 ? "0${date.day}" : date.day}\n${getWeekday(date.weekday)}  ${weather.rainType}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: textColor,
                height: 1.3
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 80)),

            const Padding(padding: EdgeInsets.only(bottom: 20)),
            Text(
              "습도 ${weather.Moist} | 강수량 ${weather.Rain}",
              style: TextStyle(
                color: weather.isNight ? background.withOpacity(0.6) : textColor.withOpacity(0.6),
                fontSize: 18,
              ),
            ),
          ],
        )
    );
  }
}
