LocationService _locationService;

LocationService get locationService {
  if (_locationService == null) {
    _locationService = LocationService();
  }
  return _locationService;
}

class LocationService {

}