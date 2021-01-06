import 'dart:html';

import 'package:air_asia_flight_search/model/flight_stop.dart';
import 'package:air_asia_flight_search/ticket_page.dart';
import 'package:air_asia_flight_search/widgets/animated_dot.dart';
import 'package:air_asia_flight_search/widgets/flight_stop_card.dart';
import 'package:flutter/material.dart';

class PriceTab extends StatefulWidget {
  final double height;

  const PriceTab({Key key, this.height}) : super(key: key);

  @override
  _PriceTabState createState() => _PriceTabState();
}

class _PriceTabState extends State<PriceTab> with TickerProviderStateMixin {
  // Flight stops
  final List<FlightStop> _flightStops = [
    FlightStop("JFK", "ORY", "JUN 05", "6h 25m", "\$851", "9:26 am - 3:43 pm"),
    FlightStop("MRG", "FTB", "JUN 20", "6h 25m", "\$532", "9:26 am - 3:43 pm"),
    FlightStop("ERT", "TVS", "JUN 20", "6h 25m", "\$718", "9:26 am - 3:43 pm"),
    FlightStop("KKR", "RTY", "JUN 20", "6h 25m", "\$663", "9:26 am - 3:43 pm"),
  ];

  final List<GlobalKey<FlightStopCardState>> _flightStopKey = [];

  //Plane size animation
  AnimationController _planeSizeAnimationController;
  Animation _planeSizeAnimation;

  //Plane travel animation
  AnimationController _planeTravelAnimationController;
  Animation _planeTravelAnimation;

  final double _initialPlanePaddingBottom = 16.0;
  final double _minPlanePaddingTop = 16.0;

  double get _planeTopPadding =>
      _minPlanePaddingTop +
      (1 - _planeTravelAnimation.value) * _maxPlaneTopPadding;

  double get _maxPlaneTopPadding =>
      widget.height - _initialPlanePaddingBottom - _planeSize;

  double get _planeSize => _planeSizeAnimation.value;

  //Plane stop dots
  // final List<int> _flightStops = [1, 2, 3, 4];
  final double _cardHeight = 80.0;

  AnimationController _dotsAnimationController;
  List<Animation<double>> _dotsAnimation = [];

  // Floating action button
  AnimationController _fabAnimationController;
  Animation _fabAnimation;

  @override
  void initState() {
    _flightStops.forEach((flightStop) {
      _flightStopKey.add(GlobalKey<FlightStopCardState>());
    });
    print(_flightStopKey[0].currentState);
    _initPlaneSizeAnimation();
    _initPlaneTravelAnimation();
    _initDotsAnimationController();
    _initDotsAnimation();
    _initFABAnimationController();
    _planeSizeAnimationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _planeSizeAnimationController.dispose();
    _planeTravelAnimationController.dispose();
    _dotsAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  _initPlaneSizeAnimation() {
    _planeSizeAnimationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              // Plane travel animation starts
              Future.delayed(
                Duration(milliseconds: 500),
                () => _planeTravelAnimationController.forward(),
              );

              // Dots animation starts
              Future.delayed(
                Duration(milliseconds: 700),
                () => _dotsAnimationController.forward(),
              );
            }
          });

    _planeSizeAnimation = Tween<double>(begin: 60.0, end: 36.0).animate(
        CurvedAnimation(
            parent: _planeSizeAnimationController, curve: Curves.easeOut));
  }

  _initPlaneTravelAnimation() {
    _planeTravelAnimationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _planeTravelAnimation = CurvedAnimation(
        parent: _planeTravelAnimationController, curve: Curves.fastOutSlowIn);
  }

  _initDotsAnimation() {
    final double slideDurationInterval = 0.4;
    final double slideDelayInterval = 0.2;

    //Start at the bottom of the screen
    double startMarginTop = widget.height;
    print("Start Marigin top: $startMarginTop");
    // Minimal margin from top (where the first dot will be placed)
    double minMarginTop =
        _minPlanePaddingTop + _planeSize + 0.5 * (0.8 * _cardHeight);

    for (int i = 0; i < _flightStops.length; i++) {
      final start = slideDelayInterval * i;
      final end = start + slideDurationInterval;

      double finalMarginTop = minMarginTop + i * (0.8 * _cardHeight);
      print("finalMarginTop: $finalMarginTop");

      Animation<double> animation =
          Tween<double>(begin: startMarginTop, end: finalMarginTop).animate(
        CurvedAnimation(
          parent: _dotsAnimationController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );

      _dotsAnimation.add(animation);
    }
  }

  _initDotsAnimationController() {
    _dotsAnimationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animateFlightStopCards().then((_) => _animateFAB());
            }
          });
  }

  _initFABAnimationController() {
    _fabAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _fabAnimation =
        CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeOut);
  }

  _animateFAB() {
    _fabAnimationController.forward();
  }

  Future _animateFlightStopCards() async {
    return await Future.forEach<GlobalKey<FlightStopCardState>>(_flightStopKey,
        (flightStopKey) async {
      return await Future.delayed(Duration(milliseconds: 250), () {
        flightStopKey.currentState.runAnimation();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildPlane(),
        ]
          ..addAll(_flightStops.map(_buildStopCard))
          ..addAll(_flightStops.map(_mapFlightTopToDot))
          ..add(_buildFAB()),
      ),
    );
  }

  Widget _buildPlane() {
    return AnimatedBuilder(
      animation: _planeTravelAnimation,
      child: Column(
        children: [
          AnimatedPlaneIcon(
            animation: _planeSizeAnimation,
          ),
          Container(
            width: 2.0,
            height: _flightStops.length * _cardHeight * 0.8,
            color: Color.fromARGB(255, 200, 200, 200),
          ),
        ],
      ),
      builder: (context, child) {
        print(_planeTravelAnimation.value);
        return Positioned(
          top: _planeTopPadding,
          child: child,
        );
      },
    );
  }

  Widget _mapFlightTopToDot(stop) {
    int index = _flightStops.indexOf(stop);
    bool isStartOrEnd = index == 0 || index == _flightStops.length - 1;
    Color color = isStartOrEnd ? Colors.red : Colors.green;
    return AnimatedDot(
      color: color,
      animation: _dotsAnimation[index],
    );
  }

  Widget _buildStopCard(FlightStop stop) {
    int index = _flightStops.indexOf(stop);
    // double topMargin = _dotsAnimation[index].value -
    //     0.5 * (FlightStopCard.height - AnimatedDot.size);
    bool isLeft = index.isOdd;

    return AnimatedBuilder(
      animation: _dotsAnimation[index],
      builder: (context, child) => Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(
              top: _dotsAnimation[index].value -
                  0.5 * (FlightStopCard.height - AnimatedDot.size)),
          child: child,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLeft ? Container() : Expanded(child: Container()),
          Expanded(
            child: FlightStopCard(
              key: _flightStopKey[index],
              flightStop: stop,
              isLeft: isLeft,
            ),
          ),
          !isLeft ? Container() : Expanded(child: Container()),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Positioned(
      bottom: 16.0,
      child: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FadeTransition(
                opacity: _fabAnimation,
                child: TicketPage(),
              ),
            ));
          },
          child: Icon(
            Icons.check,
            size: 36.0,
          ),
        ),
      ),
    );
  }
}

class AnimatedPlaneIcon extends AnimatedWidget {
  const AnimatedPlaneIcon({
    Key key,
    @required Animation animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = super.listenable;
    return Icon(
      Icons.airplanemode_active,
      color: Colors.red,
      size: animation.value,
    );
  }
}
