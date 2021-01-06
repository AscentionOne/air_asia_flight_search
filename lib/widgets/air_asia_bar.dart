import 'package:air_asia_flight_search/constants.dart';
import 'package:flutter/material.dart';

class AirAsiaBar extends StatelessWidget {
  const AirAsiaBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: AirAsia.topBarHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red, AirAsia.primaryColor],
            ),
          ),
        ),
        AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Air Asia',
            style: TextStyle(
                fontFamily: 'NothingYouCouldDo', fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
