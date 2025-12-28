import 'package:royal/core/models/top_header_model.dart';
import 'package:royal/core/widgets/back_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:royal/core/states/mode.dart';
import 'package:get/get.dart';

class TopHeaderWidget extends StatefulWidget {
  final TopHeaderModel data;
  final bool showBackButton;
  const TopHeaderWidget(
      {super.key, required this.data, this.showBackButton = true});

  @override
  State<TopHeaderWidget> createState() => _TopHeaderWidgetState();
}

class _TopHeaderWidgetState extends State<TopHeaderWidget> {
  final LightningModeController lightningModeController =
      Get.find<LightningModeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             widget.showBackButton ? const BackNavigationWidget() : const SizedBox(),
              Text(
                widget.data.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: lightningModeController.currentMode.value.mode ==
                            "light"
                        ? Colors.black
                        : Colors.white,
                    fontSize: 17.22,
                    fontWeight: FontWeight.w600,
                    height: 1.33),
              ),
              SizedBox(child: widget.data.child ?? const SizedBox())
            ],
          ),
        ));
  }
}
