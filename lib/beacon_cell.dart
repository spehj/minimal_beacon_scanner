import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_estibeacon_scanner/constants/app_styles.dart';
import 'package:simple_estibeacon_scanner/data/ibeacon_model.dart';

class BeaconCell extends StatelessWidget {
  final Function() onTap;
  final IBeaconModel beacon;

  const BeaconCell({
    super.key,
    required this.onTap,
    required this.beacon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                leading: SvgPicture.asset("assets/images/bluetooth.svg", color: Styles.colorDarkBlue, width: 24),
                title: const Text("iBeacon", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("MAC: ${beacon.remoteId}", overflow: TextOverflow.ellipsis),
                trailing: Text(
                  "${beacon.distance}m",
                  style: TextStyle(color: Styles.colorLightBlue, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text("Major: ${beacon.major}", style: TextStyle(fontWeight: FontWeight.bold)),
                      backgroundColor: Styles.colorLightBlue.withOpacity(0.2),
                    ),
                    Chip(
                      label: Text("Minor: ${beacon.minor}", style: TextStyle(fontWeight: FontWeight.bold)),
                      backgroundColor: Styles.colorLightBlue.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "UUID: ${beacon.uuid}",
                    style: TextStyle(fontFamily: 'Courier', color: Styles.colorLightBlue),
                    //overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
