import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'package:impact/models/distance_matrix.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:impact/screens/home/submitTrip.dart';

class Track extends StatefulWidget {
  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {
  GoogleMapController mapController;
  double _originLatitude = 52.621155, _originLongitude = 1.264509;
  double _destLatitude = 51.512376, _destLongitude = 0.006742;
  String _mapStyle;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = 'AIzaSyBKbdX5jo7zdkG7bU1G6ehiwnQXVutOGxU';

  String time = '';
  String journeyDistance = '';
  bool recording = true;
  String playing = "Pause";
  bool record = false;
  Color buttonColor = const Color(0XFFD7310E);

  @override
  void initState() {
    super.initState();

    //Map Styling
    rootBundle.loadString('assets/map_style.json').then((string) {
      _mapStyle = string;
    });

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  googleMap(),
                  titleSection(),
                  buttonRow(),
                ],
              ),
            ],
          )),
    );
  }

  Widget buttonRow() {
    if (recording == true) {
      return Positioned.fill(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 35),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(width: 25),
                FlatButton(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: buttonColor,
                      ),
                      width: 130,
                      height: 45,
                      child: Center(
                          child: Text(playing,
                              style: TextStyle(color: Colors.white)))),
                  onPressed: () {
                    setState(() {
                      if (record == false) {
                        record = true;
                        playing = "Resume";
                        buttonColor = Colors.green;
                      } else {
                        record = false;
                        playing = "Pause";
                        buttonColor = const Color(0XFFD7310E);
                      }
                    });
                  },
                ),
                FlatButton(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0XFFe1e7f0),
                      ),
                      width: 130,
                      height: 45,
                      child: Center(
                          child: Text('End Trip',
                              style: TextStyle(color: Colors.red)))),
                  onPressed: () {
                    submitTrip();
                  },
                ),
                SizedBox(width: 25),
              ],
            ),
          ),
        ),
      );
    } else {
      return Positioned.fill(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 35),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FlatButton(
                onPressed: () {
                  setState(() {
                    recording = true;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: const Color(0XFFD7310E),
                            width: 2,
                          ),
                          color: Colors.white),
                      height: 60,
                      width: 60,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0XFFD7310E)),
                      height: 48,
                      width: 48,
                    )
                  ],
                )),
          ),
        ),
      );
    }
  }

  Widget titleSection() {
    return Container(
      height: 150,
      color: const Color(0xF2091A51),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Text('Trip Tracker',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 15),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Elapsed Time',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 12)),
                      SizedBox(height: 5),
                      Text(time,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold))
                    ]),
                Container(height: 50, width: 1, color: Colors.blueGrey),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Distance',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 12)),
                      SizedBox(height: 5),
                      Text(journeyDistance,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold))
                    ])
              ])
        ],
      ),
    );
  }

  Widget googleMap() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(_originLatitude, _originLongitude), zoom: 10),
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        myLocationButtonEnabled: false,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }

  void submitTrip() {
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        context: context,
        builder: (context) =>
            SubmitTrip(distance: journeyDistance, time: time));
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    controller.setMapStyle(_mapStyle);
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        width: 4,
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBKbdX5jo7zdkG7bU1G6ehiwnQXVutOGxU',
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );

    DistanceMatrix distance = await DistanceMatrix.loadData(
        (_originLatitude.toString() + ',' + _originLongitude.toString()),
        (_destLatitude.toString() + ',' + _destLongitude.toString()));

    // print((distance.elements[0].distance.value));
    time = distance.elements[0].duration.text;
    journeyDistance = distance.elements[0].distance.text;

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
