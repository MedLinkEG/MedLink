import 'package:flutter/foundation.dart';

@immutable
class UserLocation {
  const UserLocation({required this.id, required this.name});

  static const current = UserLocation(id: 'current', name: 'Current location');

  final String id;
  final String name;

  @override
  bool operator ==(Object other) => other is UserLocation && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
