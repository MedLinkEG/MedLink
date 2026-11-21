import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medlink/features/home/domain/user_location.dart';

final savedLocationsProvider = Provider<List<UserLocation>>(
  (ref) => const [UserLocation.current],
);

class SelectedLocationNotifier extends Notifier<UserLocation> {
  @override
  UserLocation build() => UserLocation.current;

  void select(UserLocation location) => state = location;
}

final selectedLocationProvider =
    NotifierProvider<SelectedLocationNotifier, UserLocation>(
      SelectedLocationNotifier.new,
    );
