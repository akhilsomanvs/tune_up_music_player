import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tune_up/arch_utils/utils/size_config.dart';
import 'package:tune_up/arch_utils/widgets/responsize_builder.dart';
import 'package:tune_up/controllers/songs_controller.dart';
import 'package:tune_up/views/widgets/player_widget.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double usableHeight = 0;

  SongsController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    controller.getSongsFromDevice();
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          if (usableHeight < sizingInformation.localWidgetSize.height) {
            usableHeight = sizingInformation.localWidgetSize.height;
          }
          return SingleChildScrollView(
            child: SizedBox(
              height: usableHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: Container()),
                  PlayerWidget(
                    songName: 'Flume',
                    albumName: 'Say It',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
