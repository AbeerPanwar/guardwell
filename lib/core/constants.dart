class AppConstants {
  static const String appName = 'GuardWell';
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  // SOS Button
  static const double sosButtonSize = 120.0;
  static const String sosButtonText = 'SOS';
  
  // Map
  static const double defaultZoom = 16.0;
  
  // Emergency Messages
  static const String emergencyTitle = '🚨 EMERGENCY ALERT! 🚨';
  static const String emergencyMessageTemplate = 
    'I need immediate help! My current location is:\n\n'
    '📍 Latitude: {lat}\n'
    '📍 Longitude: {lng}\n\n'
    'Google Maps: https://maps.google.com/?q={lat},{lng}\n\n'
    'Please contact me or emergency services immediately!';
}