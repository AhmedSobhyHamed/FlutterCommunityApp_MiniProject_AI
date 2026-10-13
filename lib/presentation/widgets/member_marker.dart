import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A community member pinned on the map.
class MemberPin {
  const MemberPin({
    required this.name,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final String city;
  final double latitude;
  final double longitude;
}

/// Hardcoded members in three cities. Tapping a marker opens the info window.
const List<MemberPin> communityMembers = [
  MemberPin(
    name: 'Lina Hassan',
    city: 'Cairo',
    latitude: 30.0444,
    longitude: 31.2357,
  ),
  MemberPin(
    name: 'Omar Haddad',
    city: 'Dubai',
    latitude: 25.2048,
    longitude: 55.2708,
  ),
  MemberPin(
    name: 'Maya Chen',
    city: 'London',
    latitude: 51.5074,
    longitude: -0.1278,
  ),
];

/// Builds a Google Maps marker. Info windows are native, so this is not a Flutter widget.
Marker buildMemberMarker(MemberPin member, {VoidCallback? onTap}) {
  return Marker(
    markerId: MarkerId(member.name),
    position: LatLng(member.latitude, member.longitude),
    infoWindow: InfoWindow(title: member.name, snippet: member.city),
    onTap: onTap,
  );
}
