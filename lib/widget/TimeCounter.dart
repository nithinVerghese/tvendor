import 'package:flutter/material.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:timer_count_down/timer_count_down.dart';

Widget counter(BuildContext context, int second){
  return Countdown(
    // controller: controller,
    seconds: second,
    //2880+600
    build: (_, double time) => Row(
      children: [
        Duration(seconds: time.toInt()).inDays == 0 ? Text(""): Text("${Duration(seconds: time.toInt()).inDays}d ",
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontFamily: FontStrings.Roboto_SemiBold,
            color: Color(0xFF212156),),
        ),
        (Duration(seconds: time.toInt()).inHours)-((Duration(seconds: time.toInt()).inDays)*24) == 0 ? Text(""):Text(
          "${(Duration(seconds: time.toInt()).inHours)-((Duration(seconds: time.toInt()).inDays)*24)}h ",
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontFamily: FontStrings.Roboto_SemiBold,
            color: Color(0xFF212156),),
        ),
        (Duration(seconds: time.toInt()).inMinutes)-((Duration(seconds: time.toInt()).inHours)*60) == 0 ? Text(''): Text(
          "${(Duration(seconds: time.toInt()).inMinutes)-((Duration(seconds: time.toInt()).inHours)*60)}min ",
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontFamily: FontStrings.Roboto_SemiBold,
            color: Color(0xFF212156),),
        ),
        (Duration(seconds: time.toInt()).inSeconds)-((Duration(seconds: time.toInt()).inMinutes)*60) == 0 ? Text(''):Text(
          "${(Duration(seconds: time.toInt()).inSeconds)-((Duration(seconds: time.toInt()).inMinutes)*60)}sec ",
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontFamily: FontStrings.Roboto_SemiBold,
            color: Color(0xFF212156),),
        ),
        Text(
          "left",
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontFamily: FontStrings.Roboto_SemiBold,
            color: Color(0xFF212156),),
        ),
      ],
    ),
    interval: Duration(milliseconds: 100),

  );
}