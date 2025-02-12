import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_state.dart';

class MapController extends Cubit<MapState> {
  MapController() : super(MapState.initial());

  Future<void> createPolyline(LatLng latLng) async {
    emit(state.copyWith(mapStatus: MapStatus.loading));
    if (state.polylines!.polylineId.value == 'init') {
      Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: Colors.black,
        width: 4,
        points: [latLng],
      );
      Marker newStartMarker = Marker(
        draggable: true,
        onDrag: (value) {
          if (state.polygons!.polygonId.value != 'init') {
            emit(state.copyWith(mapStatus: MapStatus.loading));
            List<LatLng> oldPoints = state.polygons!.points;
            oldPoints[0] = value;
            Polygon polygon = Polygon(
                polygonId: PolygonId('polygon'),
                points: state.polylines!.points,
                strokeColor: Colors.orange,
                fillColor: const Color.fromARGB(52, 252, 218, 0),
                strokeWidth: 2);
            emit(state.copyWith(
                polygons: polygon, mapStatus: MapStatus.success));
          }
        },
        markerId: MarkerId('polydy'),
        position: latLng,
        icon: await BitmapDescriptor.asset(
            ImageConfiguration(size: Size(10, 10)), 'assets/marker_point.png'),
        onTap: () {
          emit(state.copyWith(mapStatus: MapStatus.loading));
          Polygon polygon = Polygon(
              polygonId: PolygonId('polygon'),
              points: state.polylines!.points,
              strokeColor: Colors.orange,
              fillColor: const Color.fromARGB(52, 252, 218, 0),
              strokeWidth: 2);
          emit(state.copyWith(polygons: polygon, mapStatus: MapStatus.success));
        },
      );
      emit(state.copyWith(polylines: polyline, startMarker: newStartMarker));
    } else {
      final marker = Marker(
        draggable: true,
        onDragStart: (value) {
          int index = state.polygons!.points.indexOf(value);
          emit(state.copyWith(counterIndex: index));
        },
        onDrag: (value) {
          emit(state.copyWith(mapStatus: MapStatus.loading));
          List<LatLng> latLngList = state.polygons!.points;
          latLngList[state.counterIndex] = value;
          Polygon polygon = Polygon(
            polygonId: PolygonId('polygon'),
            points: latLngList,
            strokeColor: Colors.orange,
            fillColor: const Color.fromARGB(52, 252, 218, 0),
            strokeWidth: 2,
          );
          emit(state.copyWith(polygons: polygon, mapStatus: MapStatus.success));
        },
        markerId: MarkerId(state.im.toString()),
        position: latLng,
        icon: await BitmapDescriptor.asset(
            ImageConfiguration(size: Size(10, 10)), 'assets/marker_point.png'),
      );
      List<LatLng> oldPoints = state.polylines!.points;
      oldPoints.add(latLng);
      Polyline newPolyline = Polyline(
        polylineId: PolylineId('poly'),
        color: Colors.black,
        width: 4,
        points: oldPoints,
      );
      state.markers.add(marker);
      emit(state.copyWith(polylines: newPolyline));
    }
    emit(state.copyWith(mapStatus: MapStatus.success, im: state.im + 1));
  }
}
