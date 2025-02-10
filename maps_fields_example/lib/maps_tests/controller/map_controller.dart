import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_state.dart';

class MapController extends Cubit<MapState> {
  MapController() : super(MapState.initial());

  void getStartPosition(LatLng value) {
    emit(state.copyWith(mapStatus: MapStatus.loading));

    Polyline newPolyline = Polyline(
      polylineId: PolylineId("newPolyline"),
      color: Colors.black,
      width: 6,
      points: [value, value],
    );

    emit(state.copyWith(mapStatus: MapStatus.success, polylines: newPolyline));
  }

  void getDuringDrag(LatLng value) {
    emit(state.copyWith(mapStatus: MapStatus.loading));

    if (state.polylines != null) {
      state.polylines!.points[1] = value;
      emit(state.copyWith(
          mapStatus: MapStatus.success, polylines: state.polylines));
    }
  }

  void createPolyline(LatLng argument) {
    emit(state.copyWith(mapStatus: MapStatus.loading));
    if (state.polylines!.polylineId.value == "initialPolyline") {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polylineId'),
        color: Colors.black,
        width: 2,
        points: [argument],
      );
      emit(state.copyWith(
        polylines: polyline,
      ));
    } else {
      List<LatLng> oldPoints = List.from(state.polylines!.points)
        ..add(argument);
      Polyline existingPolyline =
          state.polylines!.copyWith(pointsParam: oldPoints);
      emit(state.copyWith(polylines: existingPolyline));
    }
    emit(state.copyWith(mapStatus: MapStatus.success));
  }
}
