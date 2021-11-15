import 'package:flutter/material.dart';
import 'package:tune_up/arch_utils/utils/size_config.dart';
import 'package:tune_up/arch_utils/widgets/responsize_builder.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  double usableHeight=0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context,sizingInformation){
          if(usableHeight < sizingInformation.localWidgetSize.height){
            usableHeight = sizingInformation.localWidgetSize.height;
          }
          return SingleChildScrollView(
            child: SizedBox(
              height: usableHeight,
              child: Container(),
            ),
          );
        },
      ),
    );
  }
}
