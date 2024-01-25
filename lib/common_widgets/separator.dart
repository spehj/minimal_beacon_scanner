import 'package:flutter/material.dart';
import 'package:simple_estibeacon_scanner/constants/app_sizes.dart';
import 'package:simple_estibeacon_scanner/constants/app_styles.dart';

class Separator extends StatelessWidget {
  final Color? color;
  final bool noTopMargin;
  const Separator({Key? key, this.color, this.noTopMargin = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: noTopMargin ? 0 : 16, bottom: 0),
      width: double.infinity,
      height: Sizes.p4,
      color: (color ?? Styles.colorGray),
    );
  }
}
