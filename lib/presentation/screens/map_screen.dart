import 'package:flutter/material.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/app_bottom_nav.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/member_marker.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/profile_icon_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;

  Set<Marker> get _markers {
    return {
      for (final member in communityMembers)
        buildMemberMarker(
          member,
          onTap: () => _controller?.showMarkerInfoWindow(MarkerId(member.name)),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Map'),
        actions: const [ProfileIconButton()],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(38, 25),
          zoom: 3.2,
        ),
        markers: _markers,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (controller) => _controller = controller,
      ),
      bottomNavigationBar: AppBottomNav(
        index: 1,
        onSelected: (index) {
          if (index == 0) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
