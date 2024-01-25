import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:simple_estibeacon_scanner/data/ibeacon_model.dart';
import 'beacon_cell.dart';

class ScanBeaconsScreen extends StatefulWidget {
  const ScanBeaconsScreen({super.key});

  @override
  State<ScanBeaconsScreen> createState() => _ScanBeaconsScreenState();
}

class _ScanBeaconsScreenState extends State<ScanBeaconsScreen> {
  // StreamSubscription<List<ScanResult>?>? _scanSubscription;
  Map<String, dynamic> devicesMap = {};
  List<IBeaconModel> beacons = [];
  bool scanning = false;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    // _scanSubscription?.cancel();
    super.dispose();
  }

  Map<String, dynamic> convertAdvertisementDataToIBeaconData(ScanResult scanResult) {
    Map<String, dynamic> iBeaconData = {};

    if (scanResult.advertisementData.manufacturerData.containsKey(76) &&
        scanResult.advertisementData.manufacturerData[76]!.length == 23 &&
        scanResult.advertisementData.manufacturerData[76]![0] == 2 &&
        scanResult.advertisementData.manufacturerData[76]![1] == 21) {
      // print(">>>>> iBeacon found: ${scanResult.advertisementData.manufacturerData[76]}");
      List<int>? data = scanResult.advertisementData.manufacturerData[76];
      iBeaconData['remoteId'] = scanResult.device.remoteId.str;
      iBeaconData['type'] = data![0];
      iBeaconData['length'] = data[1];
      iBeaconData['uuid'] = IBeaconModel.convertToUUID(data.sublist(2, 18));
      iBeaconData['major'] = IBeaconModel.convertToInt(data.sublist(18, 20));
      iBeaconData['minor'] = IBeaconModel.convertToInt(data.sublist(20, 22));
      iBeaconData['pwr'] = data[22];
      iBeaconData['rssi'] = scanResult.rssi;
    }

    return iBeaconData;
  }

  Future<void> startScan() async {
    setState(() {
      scanning = true;
      beacons.clear();
    });
    // Start scanning
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4), androidUsesFineLocation: true);

    var _scanSubscription = FlutterBluePlus.scanResults.listen((scanResult) {
      for (var result in scanResult) {
        Map<String, dynamic> iBeaconData = convertAdvertisementDataToIBeaconData(result);
        if (iBeaconData.isNotEmpty) {
          IBeaconModel beacon = IBeaconModel.fromMap(iBeaconData);
          // Add to list of beacons if not already in list based on remoteID
          if (!beacons.any((element) => element.uuid == beacon.uuid)) {
            setState(() {
              beacons.add(beacon);
            });
          }
        }
      }
    });
    FlutterBluePlus.cancelWhenScanComplete(_scanSubscription);
    await FlutterBluePlus.isScanning.where((value) => value == false).first;
    setState(() {
      scanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minimal Beacon Scanner', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          await startScan();
        },
        child: ListView.builder(
          itemCount: beacons.length + 1,
          itemBuilder: (context, index) {
            if (index == beacons.length) {
              return const SizedBox(height: 40);
            } else {
              // Get list of beacons
              var beacon = beacons[index];
              return BeaconCell(
                onTap: () {
                  // Implement your onTap functionality
                },
                beacon: beacon,
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (scanning) {
            FlutterBluePlus.stopScan();
            setState(() => scanning = false);
          } else {
            startScan();
          }
        },
        child: Icon(
          scanning ? Icons.stop : Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }
}
