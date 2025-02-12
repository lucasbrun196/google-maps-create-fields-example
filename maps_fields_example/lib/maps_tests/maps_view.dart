import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_fields_example/maps_tests/controller/map_controller.dart';

class MapsView extends StatefulWidget {
  final MapController mapController = MapController();
  MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  GoogleMapController? googleMapControllerGlobal;

  void onMapCreatedd(GoogleMapController googleMapController) {
    googleMapControllerGlobal = googleMapController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MapController, MapState>(
        buildWhen: (previous, current) =>
            previous.mapStatus != current.mapStatus,
        bloc: widget.mapController,
        builder: (context, state) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GoogleMap(
              onMapCreated: (controller) => onMapCreatedd(controller),
              onTap: (argument) =>
                  widget.mapController.createPolyline(argument),
              markers: {
                ...state.markers,
                state.startMarker,
                Marker(
                  draggable: true,
                  markerId: MarkerId("idMarker"),
                  position: LatLng(-28.257380, -52.343387),
                ),
              },
              polylines: {state.polylines!},
              polygons: {state.polygons!},
              minMaxZoomPreference: MinMaxZoomPreference(5, 200),
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: LatLng(-28.257380, -52.343387),
              ),
            ),
          );
        },
      ),
    );
  }
}
