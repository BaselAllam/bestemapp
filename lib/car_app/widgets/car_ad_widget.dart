import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/app_settings_app/widgets/custom_image_widget.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/car_app/screens/car_ads_details_screen.dart';
import 'package:bestemapp/car_app/screens/edit_car_ad_screen.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_widgets/fav_widget.dart';
import 'package:bestemapp/shared/shared_widgets/toaster.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CarAdWidget extends StatefulWidget {
  final bool isAdminView;
  final int wishlistIndex;
  CarAdModel carAdModel;
  CarAdWishlistModel? carAdWishlistModel;
  CarAdWidget({required this.carAdModel, this.isAdminView = false, this.wishlistIndex = 0, this.carAdWishlistModel});

  @override
  State<CarAdWidget> createState() => _CarAdWidgetState();
}

class _CarAdWidgetState extends State<CarAdWidget> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width /1.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          BlocProvider.of<CarCubit>(context).getCarAdDetail(widget.carAdModel);
          Navigator.push(context, CupertinoPageRoute(builder: (_) => CarDetailScreen(carAdModel: widget.carAdModel, isAdmin: widget.isAdminView,)));
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemCount: widget.carAdModel.adImgs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.grey[300],
                          child: CustomImageWidget(img: widget.carAdModel.adImgs[index].image),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange[600],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          selectedLang[AppLangAssets.featured]!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          widget.carAdModel.carCondition.replaceFirst(
                            widget.carAdModel.carCondition[0], 
                            widget.carAdModel.carCondition[0].toUpperCase()
                          ),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: widget.isAdminView ? Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        shape: BoxShape.circle
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        color: AppColors.greyColor,
                        iconSize: 15.0,
                        onPressed: () {
                          Navigator.push(context, CupertinoPageRoute(builder: (_) => CarAdEditScreen(carAd: widget.carAdModel)));
                        },
                      ),
                    ) : FavButton(carAdModel: widget.carAdModel)
                  ),
                ),
                // Image indicators
                if (widget.carAdModel.adImgs.length > 1)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.carAdModel.adImgs.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.carAdModel.adTitle,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified,
                          color: Colors.green[700],
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey[300]!, width: 1),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: CustomImageWidget(img: '${widget.carAdModel.carMake['make_logo']}', fit: BoxFit.contain,)
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.carAdModel.carMake['make_name']!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              widget.carAdModel.carModel.modelName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.carAdModel.price.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}EGP',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      if (widget.isAdminView)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.carAdModel.adStatus == 'sold' 
                              ? Colors.red[50] 
                              : widget.carAdModel.adStatus == 'active'
                                  ? Colors.green[50]
                                  : Colors.orange[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: widget.carAdModel.adStatus == 'sold'
                                ? Colors.red[200]!
                                : widget.carAdModel.adStatus == 'active'
                                    ? Colors.green[200]!
                                    : Colors.orange[200]!,
                          ),
                        ),
                        child: Text(
                          widget.carAdModel.adStatus.replaceFirst(
                            widget.carAdModel.adStatus[0],
                            widget.carAdModel.adStatus[0].toUpperCase()
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: widget.carAdModel.adStatus == 'sold'
                                ? Colors.red[700]
                                : widget.carAdModel.adStatus == 'active'
                                    ? Colors.green[700]
                                    : Colors.orange[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(Icons.calendar_today, '${widget.carAdModel.carYear}'),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.speed, '${widget.carAdModel.kilometers} km'),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.local_gas_station, widget.carAdModel.fuelType),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        widget.carAdModel.adArea.areaName,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        _formatCreationDate(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        '${_formatViewsCount()} ${selectedLang[AppLangAssets.adViews]}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildSellerAvatar(),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.carAdModel.seller.firstName} ${widget.carAdModel.seller.lastName}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          selectedLang[AppLangAssets.viewDetails]!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.blue[700],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isAdminView)
            BlocConsumer<CarCubit, CarStates>(
              listener: (context, state) {
                if (state is UpdateCarAdsErrorState || state is UpdateCarAdsSomeThingWentWrongState) {
                  Toaster.show(context, message: selectedLang[AppLangAssets.someThingWentWrong]!, position: ToasterPosition.top, type: ToasterType.error);
                } else if (state is UpdateCarAdsSuccessState) {
                  Toaster.show(context, message: selectedLang[AppLangAssets.success]!, position: ToasterPosition.top, type: ToasterType.success);
                }
              },
              builder: (context, state) => Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state is UpdateCarAdsLoadingState || widget.carAdModel.adStatus == 'deleted' ? () {} : () {
                          BlocProvider.of<CarCubit>(context).updateCarAdStatus(carAd: widget.carAdModel, newStatus: 'deleted');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state is UpdateCarAdsLoadingState || widget.carAdModel.adStatus == 'deleted' ? Colors.grey : Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is UpdateCarAdsLoadingState ? Text(selectedLang[AppLangAssets.loading]!) : Text(selectedLang[AppLangAssets.deleteAd]!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state is UpdateCarAdsLoadingState || widget.carAdModel.adStatus == 'sold' ? () {} : () {
                          BlocProvider.of<CarCubit>(context).updateCarAdStatus(carAd: widget.carAdModel, newStatus: 'sold');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state is UpdateCarAdsLoadingState || widget.carAdModel.adStatus == 'sold' ? Colors.grey : Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is UpdateCarAdsLoadingState ? Text(selectedLang[AppLangAssets.loading]!) : Text(selectedLang[AppLangAssets.markAdAsSold]!),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatViewsCount() {
    if (widget.carAdModel.viewsCount < 1000) {
      return widget.carAdModel.viewsCount.toString();
    } else {
      return '${widget.carAdModel.viewsCount.toString().substring(0, 2)} K';
    }
  }

  String _formatCreationDate() {
    
    final DateTime createdDate = DateTime.parse(widget.carAdModel.submittedAt);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(createdDate);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ${selectedLang[AppLangAssets.ago]}';
      }
      return '${difference.inHours}h ${selectedLang[AppLangAssets.ago]}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ${selectedLang[AppLangAssets.ago]}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ${selectedLang[AppLangAssets.ago]}';
    } else {
      return DateFormat('MMM d, yyyy').format(createdDate);
    }
  }

  Widget _buildSellerAvatar() {
    final String? sellerLogo = widget.carAdModel.seller.profilePicture;
    final bool hasLogo = sellerLogo != null && sellerLogo.isNotEmpty;

    if (hasLogo) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CustomImageWidget(img: sellerLogo)
        ),
      );
    } else {
      return _buildInitialsAvatar();
    }
  }

  Widget _buildInitialsAvatar() {
    final String firstName = widget.carAdModel.seller.firstName;
    final String lastName = widget.carAdModel.seller.lastName;
    
    String initials = '';
    if (firstName.isNotEmpty) {
      initials += firstName[0].toUpperCase();
    }
    if (lastName.isNotEmpty) {
      initials += lastName[0].toUpperCase();
    }
    if (initials.length < 2 && firstName.length >= 2) {
      initials = firstName.substring(0, 2).toUpperCase();
    }
    final int colorIndex = (firstName.codeUnitAt(0) + lastName.codeUnitAt(0)) % 5;
    final List<Color> avatarColors = [
      AppColors.primaryColor,
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
    ];

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            avatarColors[colorIndex],
            avatarColors[colorIndex].withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: avatarColors[colorIndex].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}