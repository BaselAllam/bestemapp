import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_widgets/toaster.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavButton extends StatefulWidget {
  CarAdModel carAdModel;
  FavButton({required this.carAdModel});

  @override
  State<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> {
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
        } else if (state is HandleCardAdWishlistSuccessState) {
          Toaster.show(
            context,
            message: selectedLang[AppLangAssets.success]!,
            type: ToasterType.success,
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
          onPressed: state is HandleCardAdWishlistLoadingState ? () {} : () {
            BlocProvider.of<CarCubit>(context).handleCarAdWishlist(carAd: widget.carAdModel);
          },
          icon: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: widget.carAdModel.isFav ? 0.0 : 1.0, end: widget.carAdModel.isFav ? 1.0 : 0.0),
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    widget.carAdModel.isFav ? Icons.favorite : Icons.favorite_border,
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