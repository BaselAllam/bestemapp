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

class _FavButtonState extends State<FavButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_animationController);

    _fillAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.carAdModel.isFav) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.carAdModel.isFav) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    BlocProvider.of<CarCubit>(context).handleCarAdWishlist(carAd: widget.carAdModel);
  }

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
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: state is HandleCardAdWishlistLoadingState ? () {} : _handleTap,
          icon: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow effect when favorited
                    if (_fillAnimation.value > 0.5)
                      Icon(
                        Icons.favorite,
                        color: AppColors.redColor.withOpacity(0.3),
                        size: 24.0 + (4.0 * (_fillAnimation.value - 0.5) * 2),
                      ),
                    // Base icon (border or filled)
                    Icon(
                      Icons.favorite_border,
                      color: AppColors.redColor,
                      size: 20.0,
                    ),
                    // Animated fill
                    ClipRect(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: _fillAnimation.value,
                        child: Icon(
                          Icons.favorite,
                          color: AppColors.redColor,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}