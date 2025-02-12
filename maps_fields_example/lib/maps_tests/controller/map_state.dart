part of 'map_controller.dart';

enum MapStatus { initial, loading, success }

class MapState extends Equatable {
  final MapStatus mapStatus;
  final Polyline? polylines;
  final Polygon? polygons;
  final Marker startMarker;
  final Set<Marker> markers;
  final int counterIndex, im;

  const MapState({
    required this.im,
    required this.counterIndex,
    required this.mapStatus,
    this.polylines,
    this.polygons,
    required this.startMarker,
    required this.markers,
  });
  @override
  List<Object?> get props =>
      [mapStatus, polylines, polygons, startMarker, markers, counterIndex, im];

  MapState.initial()
      : this(
            im: 0,
            counterIndex: 0,
            mapStatus: MapStatus.initial,
            startMarker: Marker(markerId: MarkerId('intialMarker')),
            polygons: Polygon(polygonId: PolygonId('init')),
            polylines: Polyline(polylineId: PolylineId("init")),
            markers: {});

  MapState copyWith({
    MapStatus? mapStatus,
    Polyline? polylines,
    Polygon? polygons,
    Marker? startMarker,
    Set<Marker>? markers,
    int? counterIndex,
    int? im,
  }) {
    return MapState(
      counterIndex: counterIndex ?? this.counterIndex,
      mapStatus: mapStatus ?? this.mapStatus,
      polylines: polylines ?? this.polylines,
      polygons: polygons ?? this.polygons,
      startMarker: startMarker ?? this.startMarker,
      markers: markers ?? this.markers,
      im: im ?? this.im,
    );
  }
}
