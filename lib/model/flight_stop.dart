class FlightStop {
  String from;
  String to;
  String date;
  String duration;
  String price;
  String fromToTime;

  FlightStop(
    this.from,
    this.to,
    this.date,
    this.duration,
    this.price,
    this.fromToTime,
  );
}

class FlightStopTicket {
  String from;
  String fromShort;
  String to;
  String toShort;
  String flightNumber;

  FlightStopTicket(
    this.from,
    this.fromShort,
    this.to,
    this.toShort,
    this.flightNumber,
  );
}
