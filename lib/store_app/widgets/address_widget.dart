import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:flutter/material.dart';


class AddressWidget extends StatefulWidget {
  const AddressWidget({super.key});

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ListTile(
          title: Text('Address Name', style: AppFonts.primaryFontBlackColor),
          subtitle: Text('1232 Shorok City, Cairo, Egypt', style: AppFonts.subFontGreyColor),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            color: AppColors.greyColor,
            iconSize: 25,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}