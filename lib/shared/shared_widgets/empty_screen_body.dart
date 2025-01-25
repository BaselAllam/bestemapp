import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:flutter/material.dart';



class EmptyScreenBody extends StatelessWidget {
  final String img;
  final String title;
  final String subTitle;
  const EmptyScreenBody({required this.img, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(img),
                fit: BoxFit.fill
              )
            ),
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppFonts.primaryFontBlackColor,
        ),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: AppFonts.subFontBlackColor,
        ),
      ],
    );
  }
}