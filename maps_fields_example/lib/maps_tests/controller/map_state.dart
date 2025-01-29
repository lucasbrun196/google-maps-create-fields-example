part of 'map_controller.dart';

enum MapStatus { initial, loading, success, error }

class MapState extends Equatable {
  final MapStatus mapStatus;
  final Polyline? polylines;

  const MapState({required this.mapStatus, required this.polylines});

  @override
  List<Object?> get props => [mapStatus, polylines];

  MapState.initial()
      : this(
            mapStatus: MapStatus.initial,
            polylines: Polyline(polylineId: PolylineId("initialPolyline")));

  MapState copyWith({
    MapStatus? mapStatus,
    Polyline? polylines,
  }) {
    return MapState(
      mapStatus: mapStatus ?? this.mapStatus,
      polylines: polylines ?? this.polylines,
    );
  }
}
