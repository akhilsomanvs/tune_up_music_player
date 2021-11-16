import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tune_up/app_utils/app_assets.dart';
import 'package:tune_up/app_utils/app_colours.dart';
import 'package:tune_up/arch_utils/utils/size_config.dart';
import 'package:tune_up/arch_utils/widgets/spacing_widgets.dart';
import 'package:tune_up/controllers/player_controller.dart';

class PlayerWidget extends StatefulWidget {
  final String songName;
  final String albumName;

  final Function(bool)? onPlayButtonTap;
  final Function? onPrevButtonTap;
  final Function? onNextButtonTap;

  PlayerWidget({Key? key, required this.songName, this.albumName = "", this.onPlayButtonTap, this.onPrevButtonTap, this.onNextButtonTap}) : super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> with TickerProviderStateMixin {
  PlayerController controller = Get.find();

  //Record rotation Animation
  late AnimationController rotationController;
  late Animation rotationAnimation;

  //Record Scale Animation
  late AnimationController scaleAnimController;
  late Animation scaleAnimation;

  //Slide Up Animation
  late AnimationController slideUpAnimController;
  late Animation slideUpAnimation;

  //Progress Indicator
  late AnimationController progressAnimController;
  late Animation progressAnimation;

  @override
  void initState() {
    rotationController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(rotationController);
    rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        rotationController.reset();
        rotationController.forward();
      }
    });

    scaleAnimController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    scaleAnimation = Tween<double>(begin: 0.9, end: 1.2).animate(scaleAnimController);

    slideUpAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    slideUpAnimation = Tween<Offset>(begin: const Offset(0, 100), end: const Offset(0, 0)).animate(slideUpAnimController);

    progressAnimController = AnimationController(vsync: this, duration: const Duration(minutes: 1, seconds: 30));
    progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(progressAnimController);
    progressAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        progressAnimController.reset();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double bottomPadding = SizeConfig.getBottomScreenPadding() + SizeConfig.getVerticalSize(12);
    return Stack(
      children: [
        ///
        ///Music Details Container
        ///
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 16.hdp(),
            ),
            child: AnimatedBuilder(
              animation: slideUpAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: slideUpAnimation.value,
                  child: child,
                );
              },
              child: slideUpContainerWidget(
                widget.songName,
                albumName: widget.albumName,
              ),
            ),
          ),
        ),

        ///
        ///Player Icons Holder
        ///
        Padding(
          padding: EdgeInsets.only(top: 80.vdp()),
          child: miniMusicPlayer(bottomPadding),
        ),

        ///
        ///Record Holder
        ///
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 4,
                  child: AnimatedBuilder(
                    animation: scaleAnimation,
                    child: AnimatedBuilder(
                      animation: rotationAnimation,
                      child: Container(
                        width: 110.vdp(),
                        height: 110.vdp(),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                          image: DecorationImage(image: AssetImage(AppAssets.getImagePath("album_placeholder.png")), fit: BoxFit.contain),
                        ),
                        child: Center(
                          child: Container(
                            width: 24.vdp(),
                            height: 24.vdp(),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(300), color: Colors.white),
                          ),
                        ),
                      ),
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: rotationAnimation.value,
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                    ),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: scaleAnimation.value,
                        alignment: Alignment.bottomCenter,
                        child: child,
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  //region Widget methods
  miniMusicPlayer(double bottomPadding){
    return Container(
      // height: SizeConfig.getVerticalSize(100),
      padding: EdgeInsets.only(
        left: 12.hdp(),
        right: 12.hdp(),
        top: 12.vdp(),
        bottom: bottomPadding,
      ),
      decoration: BoxDecoration(
        color: colorAppPrimaryWhite,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.vdp()),
          topLeft: Radius.circular(12.vdp()),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            offset: const Offset(0, -5),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(flex: 4, child: Container()),
          Flexible(
            flex: 2,
            child: PlayerIcon(
              icon: Icons.skip_previous,
              onTap: (isActive) {
                if (widget.onPrevButtonTap != null) {
                  widget.onPrevButtonTap!();
                }
              },
            ),
          ),
          HSpace(8),
          Flexible(
            flex: 2,
            child: PlayerIcon(
              icon: Icons.play_arrow,
              activeIcon: Icons.pause,
              canBeActive: true,
              isActive: controller.isPlaying.value,
              onTap: (isActive) {
                controller.setIsPlaying(isActive);
                triggerRecordAnimation(isActive);
                if (widget.onPlayButtonTap != null) {
                  widget.onPlayButtonTap!(isActive);
                }
              },
            ),
          ),
          HSpace(8),
          Flexible(
            flex: 2,
            child: PlayerIcon(
              icon: Icons.skip_next,
              onTap: (isActive) {
                if (widget.onNextButtonTap != null) {
                  widget.onNextButtonTap!();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  slideUpContainerWidget(String songName,{String albumName=""}){
    return Container(
      width: double.infinity,
      height: 110.vdp(),
      padding: EdgeInsets.symmetric(
        vertical: 12.vdp(),
        horizontal: 12.hdp(),
      ),
      decoration: BoxDecoration(
        color: colorAppPrimaryWhite,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.vdp()),
          topLeft: Radius.circular(12.vdp()),
        ),
        boxShadow: [
          BoxShadow(
            color: colorAppPrimaryWhite.withOpacity(0.3),
            offset: const Offset(0, -5),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(flex: 4, child: Container()),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  songName,
                  style: TextStyle(fontSize: 16.sp(), fontWeight: FontWeight.w600),
                ),
                Text(
                  albumName,
                  style: TextStyle(fontSize: 12.sp(), color: colorGreyText),
                ),
                Expanded(flex: 1, child: Container()),
                AnimatedBuilder(
                  animation: progressAnimation,
                  builder: (context, child) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        color: colorAppPrimary,
                        backgroundColor: colorAppPrimaryWhite,
                        value: progressAnimation.value,
                      ),
                    );
                  },
                ),
                Expanded(flex: 2, child: Container()),
              ],
            ),
          ),
        ],
      ),
    );
  }
  //endregion

  void triggerRecordAnimation(bool isActive) {
    if (isActive) {
      rotationController.forward();
      scaleAnimController.forward();
      progressAnimController.forward();
      slideUpAnimController.forward();
    } else {
      progressAnimController.stop(canceled: false);
      slideUpAnimController.reverse();
      scaleAnimController.reverse().then((value) {
        rotationController.stop(canceled: false);
      });
    }
  }
}

class PlayerIcon extends StatefulWidget {
  final IconData icon;
  final IconData? activeIcon;
  final bool isActive;
  final bool canBeActive;
  final Function(bool)? onTap;

  PlayerIcon({
    Key? key,
    required this.icon,
    this.activeIcon,
    this.isActive = false,
    this.canBeActive = false,
    this.onTap,
  }) : super(key: key);

  @override
  _PlayerIconState createState() => _PlayerIconState();
}

class _PlayerIconState extends State<PlayerIcon> {
  bool isPressed = false;

  @override
  void initState() {
    isPressed = widget.isActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        debugPrint("TAP :::::: ");
        setState(() {
          isPressed = !isPressed;
        });

        if (widget.onTap != null) {
          widget.onTap!(isPressed);
        }
      },
      onTapUp: (details) {
        debugPrint("TAP UP :::::: ");
        if (!widget.canBeActive) {
          setState(() {
            isPressed = !isPressed;
          });
        }
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: isPressed ? colorAppGrey : colorAppPrimaryWhite,
            borderRadius: BorderRadius.circular(12.vdp()),
          ),
          child: Icon(
            widget.activeIcon == null ? widget.icon : (isPressed ? widget.activeIcon : widget.icon),
            color: isPressed ? colorAppPrimaryWhite : colorAppGrey,
          ),
        ),
      ),
    );
  }
}