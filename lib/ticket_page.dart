import 'package:air_asia_flight_search/model/flight_stop.dart';
import 'package:air_asia_flight_search/widgets/air_asia_bar.dart';
import 'package:air_asia_flight_search/widgets/ticket_card.dart';
import 'package:flutter/material.dart';

class TicketPage extends StatefulWidget {
  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> with TickerProviderStateMixin {
  List<FlightStopTicket> stops = [
    FlightStopTicket("Sahara", "SHE", "Macao", "MAC", "SE2341"),
    FlightStopTicket("Macao", "MAC", "Cape Verde", "CAP", "KU2342"),
    FlightStopTicket("Cape Verde", "CAP", "Ireland", "IRE", "KR3452"),
    FlightStopTicket("Ireland", "IRE", "Sahara", "SHE", "MR4321"),
  ];

  AnimationController _cardEnterAnimationController;
  List<Animation> _ticketAnimation;
  Animation fabAnimation;

  @override
  void initState() {
    _cardEnterAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _ticketAnimation = stops.map((flightStop) {
      int index = stops.indexOf(flightStop);
      double start = index * 0.1;
      double duration = 0.6;
      double end = start + duration;
      return Tween<double>(begin: 800.0, end: 0.0).animate(CurvedAnimation(
          parent: _cardEnterAnimationController,
          curve: Interval(start, end, curve: Curves.decelerate)));
    }).toList();
    fabAnimation = CurvedAnimation(
        parent: _cardEnterAnimationController,
        curve: Interval(0.7, 1.0, curve: Curves.decelerate));
    _cardEnterAnimationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _cardEnterAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AirAsiaBar(),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + 100.0,
            child: SingleChildScrollView(
              child: Column(
                children: stops.map((flightStop) {
                  int index = stops.indexOf(flightStop);
                  return AnimatedBuilder(
                    animation: _cardEnterAnimationController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: TicketCard(
                        stop: flightStop,
                      ),
                    ),
                    builder: (BuildContext context, Widget child) {
                      return Transform.translate(
                        offset: Offset(0.0, _ticketAnimation[index].value),
                        child: child,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Icon(Icons.fingerprint),
    );
  }
}
