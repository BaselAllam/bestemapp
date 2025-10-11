import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_widgets/toaster.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavButton extends StatefulWidget {
  FavButton();

  @override
  State<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarCubit, CarStates>(
      listener: (context, state) {
        if (state is HandleCardAdWishlistErrorState || state is HandleCardAdWishlistSomeThingWentWrongState) {
          Toaster.show(
            context,
            message: selectedLang[AppLangAssets.someThingWentWrong]!,
            type: ToasterType.error,
            position: ToasterPosition.top,
          );
        }
      },
      builder: (context, state) => Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          shape: BoxShape.circle
        ),
        alignment: Alignment.center,
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () {
            // BlocProvider.of<CarCubit>(context).handleCarAdWishlist();
            setState(() {
              isFav = !isFav;
            });
          },
          icon: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: isFav ? 1.0 : 0.0),
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: AppColors.redColor,
                    size: 20.0,
                  ),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      heightFactor: value,
                      child: Icon(
                        Icons.favorite,
                        color: AppColors.redColor,
                        size: 20.0,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      )
    );
  }
}