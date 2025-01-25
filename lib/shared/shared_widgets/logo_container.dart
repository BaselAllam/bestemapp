import 'package:bestemapp/shared/utils/app_assets.dart';
import 'package:flutter/material.dart';



class LogoContainer extends StatefulWidget {
  final Size size;
  LogoContainer({required this.size});

  @override
  State<LogoContainer> createState() => _LogoContainerState();
}

class _LogoContainerState extends State<LogoContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height,
      width: widget.size.width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage(AppAssets.bestemLogo),
          fit: BoxFit.fill
        ),
      ),
    );
  }
}