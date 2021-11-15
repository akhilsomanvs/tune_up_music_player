import 'package:flutter/material.dart';
import 'package:tune_up/arch_utils/utils/size_config.dart';

class VSpace extends StatelessWidget {
  double height = 0;

  VSpace(this.height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: SizeConfig.getVerticalSize(height));
  }
}

class HSpace extends StatelessWidget {
  double width = 0;

  HSpace(this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: SizeConfig.getHorizontalSize(width));
  }
}
