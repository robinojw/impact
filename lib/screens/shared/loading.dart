import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impact/screens/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loading extends StatelessWidget {
  final String logoName = 'assets/impact.svg';

  @override
  Widget build(BuildContext context) {
    final Widget svg =
        SvgPicture.asset(logoName, color: const Color(0XFFCADD64));
    return Container(
        decoration: backgroundGradient,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 100, height: 100, child: svg),
              SizedBox(height: 20),
              SizedBox(
                  height: 2,
                  width: 80,
                  child: LinearProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0XFFCADD64)),
                  ))
            ]));
  }
}
