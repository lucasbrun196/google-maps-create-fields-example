import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_fields_example/maps_tests/controller/map_controller.dart';

class MapsView extends StatefulWidget {
  final MapController mapController = MapController();
  MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  GoogleMapController? googleMapControllerGlobal;
  LatLng? mouseLatLng;

  void onMapCreatedd(GoogleMapController googleMapController) {
    googleMapControllerGlobal = googleMapController;
  }

  void _onMouseMove(PointerHoverEvent event) async {
    if (googleMapControllerGlobal == null) return;

    // Converte a posição da tela para coordenadas geográficas
    ScreenCoordinate screenCoordinate = ScreenCoordinate(
      x: event.localPosition.dx.toInt(),
      y: event.localPosition.dy.toInt(),
    );

    LatLng latLng =
        await googleMapControllerGlobal!.getLatLng(screenCoordinate);

    setState(() {
      mouseLatLng = latLng;
      print(mouseLatLng);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<MapController, MapState>(
      buildWhen: (previous, current) => previous.mapStatus != current.mapStatus,
      bloc: widget.mapController,
      builder: (context, state) {
        return MouseRegion(
          onHover: (event) => _onMouseMove,
          child: GoogleMap(
            onMapCreated: (controller) => onMapCreatedd(controller),
            onTap: (argument) => widget.mapController.createPolyline(argument),
            markers: {
              Marker(
                draggable: true,
                markerId: MarkerId("idMarker"),
                position: LatLng(-28.257380, -52.343387),
                // onDrag: (value) => widget.mapController.getDuringDrag(value),
                // onDragStart: (value) =>
                //     widget.mapController.getStartPosition(value),
              ),
            },
            polylines: {
              state.polylines!,
            },
            minMaxZoomPreference: MinMaxZoomPreference(5, 200),
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: LatLng(-28.257380, -52.343387),
            ),
          ),
        );
      },
    ));
  }
}
