import 'dart:math';

class IBeaconModel {
  String remoteId;
  int type;
  int length;
  String uuid;
  int major;
  int minor;
  int power;
  String? distance;
  int? rssi;

  IBeaconModel({
    required this.remoteId,
    required this.type,
    required this.length,
    required this.uuid,
    required this.major,
    required this.minor,
    required this.power,
    this.distance,
    this.rssi,
  });

  factory IBeaconModel.fromMap(Map<String, dynamic> map) {
    int pwr = map["pwr"];
    List<int> pwrBytes = [255 - pwr];
    int power = -convertToInt(pwrBytes);
    int rssi = map["rssi"];
    String? calculatedDistance = calculateBeaconDistance(power: power, rssi: rssi, N: 2.4).toStringAsFixed(1);
    return IBeaconModel(
      remoteId: map['remoteId'],
      type: map['type'],
      length: map['length'],
      uuid: map['uuid'],
      major: map['major'],
      minor: map['minor'],
      power: power,
      distance: calculatedDistance,
      rssi: rssi,
    );
  }

  static String convertToUUID(List<int> bytes) {
    String hex = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  static int convertToInt(List<int> bytes) {
    if (bytes.length == 1) {
      return bytes[0];
    }
    return bytes[0] * 256 + bytes[1];
  }

  static num calculateBeaconDistance({required int power, required int rssi, required double N}) {
    // N - path loss exponent, from 2 to 4 (based on obstacles)
    num distance = pow(10, ((power - rssi) / (10 * N)));
    return distance;
  }
}
