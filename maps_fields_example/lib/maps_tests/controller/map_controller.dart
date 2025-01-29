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
}
