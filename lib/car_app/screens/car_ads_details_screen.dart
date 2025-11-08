import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/app_settings_app/widgets/custom_image_widget.dart';
import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/car_app/widgets/report_dialog.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_widgets/fav_widget.dart';
import 'package:bestemapp/shared/utils/app_api.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class CarDetailScreen extends StatefulWidget {
  final bool isAdmin;
  CarAdModel carAdModel;
  
  CarDetailScreen({
    this.isAdmin = false,
    required this.carAdModel
  });

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  int _currentImageIndex = 0;
  final ScrollController _thumbnailScrollController = ScrollController();
  final ScrollController _mainScrollController = ScrollController();
  VideoPlayerController? _mainVideoController;
  bool _isMainVideoInitialized = false;
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _currentImageIndex = 0;
    if (widget.carAdModel.adVideo != null && widget.carAdModel.adVideo!.isNotEmpty) {
      _initializeMainVideo();
    }
    _mainScrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Show title in app bar when scrolled past header
    if (_mainScrollController.offset > 200 && !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
    } else if (_mainScrollController.offset <= 200 && _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
    }
  }

  Future<void> _initializeMainVideo() async {
    _mainVideoController = VideoPlayerController.network(
      '${AppApi.imgIp}${widget.carAdModel.adVideo}',
      httpHeaders: {"Connection": "keep-alive"},
    );
    try {
      await _mainVideoController!.initialize();
      setState(() {
        _isMainVideoInitialized = true;
      });
    } catch (e) {
      // Handle error
    }
  }

  int get totalMediaItems => (widget.carAdModel.adVideo != null ? 1 : 0) + widget.carAdModel.adImgs.length;

  @override
  void dispose() {
    _thumbnailScrollController.dispose();
    _mainScrollController.dispose();
    _mainVideoController?.dispose();
    super.dispose();
  }

  void _openImagePopup(int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return ImagePopup(
          images: widget.carAdModel.adImgs,
          initialIndex: index,
        );
      },
    );
  }

  void _selectImage(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  Widget _buildMainMediaView() {
    if (widget.carAdModel.adVideo != null && _currentImageIndex == 0) {
      if (!_isMainVideoInitialized || _mainVideoController == null) {
        return Container(
          width: double.infinity,
          height: 300,
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      
      return SizedBox(
        width: double.infinity,
        height: 300,
        child: Stack(
          fit: StackFit.expand,
          children: [
            VideoPlayer(_mainVideoController!),
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_mainVideoController!.value.isPlaying) {
                      _mainVideoController!.pause();
                    } else {
                      _mainVideoController!.play();
                    }
                  });
                },
                child: AnimatedOpacity(
                  opacity: _mainVideoController!.value.isPlaying ? 0.0 : 0.7,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    final imageIndex = widget.carAdModel.adVideo != null ? _currentImageIndex - 1 : _currentImageIndex;
    return Hero(
      tag: 'car_image_$imageIndex',
      child: CustomImageWidget(
        img: '${widget.carAdModel.adImgs[imageIndex].image}',
        width: double.infinity,
        height: 300,
      )
    );
  }

  Widget _buildThumbnailItem(int index) {
    if (widget.carAdModel.adVideo != null && index == 0) {
      return Stack(
        fit: StackFit.expand,
        children: [
          if (widget.carAdModel.adImgs.isNotEmpty)
            CustomImageWidget(img: '${widget.carAdModel.adImgs[0].image}')
          else
            Container(
              color: Colors.grey.shade300,
              child: const Icon(Icons.video_library),
            ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      );
    }
    
    final imageIndex = widget.carAdModel.adVideo != null ? index - 1 : index;
    return CustomImageWidget(img: '${widget.carAdModel.adImgs[imageIndex].image}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        controller: _mainScrollController,
        slivers: [
          // App Bar with Image Gallery
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: _showAppBarTitle ? 2 : 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _showAppBarTitle ? Colors.transparent : Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: _showAppBarTitle ? Colors.black : Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: _showAppBarTitle
                ? Text(
                    widget.carAdModel.adTitle,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  GestureDetector(
                    onTap: () => _openImagePopup(_currentImageIndex),
                    child: _buildMainMediaView(),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentImageIndex + 1}/$totalMediaItems',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Thumbnail Gallery
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                height: 80,
                child: ListView.builder(
                  controller: _thumbnailScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: totalMediaItems,
                  itemBuilder: (context, index) {
                    final isSelected = _currentImageIndex == index;
                    
                    return GestureDetector(
                      onTap: () => _selectImage(index),
                      child: Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                            width: isSelected ? 3 : 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _buildThumbnailItem(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          
          // Price & Title Section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.carAdModel.adTitle,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'EGP ${widget.carAdModel.price}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        if (widget.carAdModel.isNegotiable)
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              selectedLang[AppLangAssets.isNegotiable]!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildIconButton(Icons.share_outlined),
                      const SizedBox(width: 8),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: FavButton(carAdModel: widget.carAdModel),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Spacing
          SliverToBoxAdapter(
            child: Container(
              height: 8,
              color: Colors.grey.shade100,
            ),
          ),
          
          // Description Section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description, color: AppColors.primaryColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        selectedLang[AppLangAssets.overview]!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.carAdModel.adDescription,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Spacing
          SliverToBoxAdapter(
            child: Container(
              height: 8,
              color: Colors.grey.shade100,
            ),
          ),
          
          // Key Highlights Section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.primaryColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        selectedLang[AppLangAssets.keyHighlights]!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildHighlightCard(
                    icon: Icons.directions_car,
                    label: selectedLang[AppLangAssets.model]!,
                    value: widget.carAdModel.carModel.modelName,
                  ),
                  _buildHighlightCard(
                    icon: Icons.verified,
                    label: selectedLang[AppLangAssets.condition]!,
                    value: widget.carAdModel.carCondition,
                  ),
                  _buildHighlightCard(
                    icon: Icons.local_gas_station,
                    label: selectedLang[AppLangAssets.fuelType]!,
                    value: widget.carAdModel.fuelType,
                  ),
                  _buildHighlightCard(
                    icon: Icons.settings,
                    label: selectedLang[AppLangAssets.transmission]!,
                    value: widget.carAdModel.transmissionType,
                  ),
                  _buildHighlightCard(
                    icon: Icons.palette,
                    label: selectedLang[AppLangAssets.color]!,
                    value: widget.carAdModel.carColor.colorName,
                  ),
                  _buildHighlightCard(
                    icon: Icons.category,
                    label: selectedLang[AppLangAssets.shape]!,
                    value: widget.carAdModel.carShape.shapeName,
                  ),
                  _buildHighlightCard(
                    icon: Icons.calendar_today,
                    label: selectedLang[AppLangAssets.year]!,
                    value: widget.carAdModel.carYear.toString(),
                  ),
                  if (widget.carAdModel.distanceRange != 0)
                    _buildHighlightCard(
                      icon: Icons.speed,
                      label: selectedLang[AppLangAssets.distanceRange]!,
                      value: widget.carAdModel.distanceRange.toString(),
                    ),
                  _buildHighlightCard(
                    icon: Icons.engineering,
                    label: selectedLang[AppLangAssets.engine]!,
                    value: widget.carAdModel.engineCapacity.toString(),
                  ),
                ],
              ),
            ),
          ),

          // Spacing
          SliverToBoxAdapter(
            child: Container(
              height: 8,
              color: Colors.grey.shade100,
            ),
          ),
          
          // Specifications Section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.checklist, color: AppColors.primaryColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        selectedLang[AppLangAssets.specifications]!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...widget.carAdModel.specs.map((spec) {
                    return _buildSpecRow(
                      spec['spec']['spec'],
                      spec['spec']['spec_type'] == 'boolean'
                          ? selectedLang[AppLangAssets.included]
                          : spec['spec']['spec_type'] == 'number'
                              ? spec['value_number']
                              : spec['value_text'],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Spacing
          SliverToBoxAdapter(
            child: Container(
              height: 8,
              color: Colors.grey.shade100,
            ),
          ),
          
          // Seller Info / Admin Statistics
          SliverToBoxAdapter(
            child: widget.isAdmin
                ? const AdStatisticsCard()
                : SellerCard(
                    onReport: _showReportDialog,
                    adModel: widget.carAdModel,
                  ),
          ),

          // Bottom Spacing
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReportAdDialog(carAdModel: widget.carAdModel);
      },
    );
  }

  Widget _buildIconButton(IconData icon) {
    return InkWell(
      onTap: () {
        Share.share('${AppApi.ipAddress}/car/${widget.carAdModel.id}');
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.black, size: 22),
      ),
    );
  }

  Widget _buildHighlightCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Image Popup Widget (unchanged)
class ImagePopup extends StatefulWidget {
  final List<CarAdImg> images;
  final int initialIndex;

  const ImagePopup({
    Key? key,
    required this.images,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<ImagePopup> createState() => _ImagePopupState();
}

class _ImagePopupState extends State<ImagePopup> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          Center(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Hero(
                    tag: 'car_image_$index',
                    child: Center(
                      child: CustomImageWidget(
                        img: '${widget.images[index].image}',
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 300,
                      )
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  '${_currentIndex + 1} / ${widget.images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CustomImageWidget(img: '${widget.images[index].image}')
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced Seller Card
class SellerCard extends StatelessWidget {
  final VoidCallback onReport;
  final CarAdModel adModel;
  
  const SellerCard({
    Key? key,
    required this.onReport,
    required this.adModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: AppColors.primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                selectedLang[AppLangAssets.seller]!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: adModel.seller.profilePicture.isNotEmpty
                    ? NetworkImage(adModel.seller.profilePicture)
                    : null,
                backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                child: adModel.seller.profilePicture.isEmpty
                    ? Text(
                        adModel.seller.firstName.isNotEmpty
                            ? adModel.seller.firstName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${adModel.seller.firstName} ${adModel.seller.lastName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 14, color: Colors.green.shade700),
                          const SizedBox(width: 4),
                          Text(
                            'Verified Seller',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.flag_outlined, color: Colors.red),
                onPressed: onReport,
                tooltip: selectedLang[AppLangAssets.reportAd],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.phone),
              label: Text(selectedLang[AppLangAssets.callSeller]!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () async {
                final Uri telUri = Uri(
                  scheme: 'tel',
                  path: adModel.contactPhone.isEmpty ? adModel.seller.phone : adModel.contactPhone,
                );
                if (await canLaunchUrl(telUri)) {
                  await launchUrl(telUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open dialer')),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.chat, color: Color(0xFF25D366)),
              label: const Text(
                "WhatsApp",
                style: TextStyle(color: Color(0xFF25D366), fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFF25D366), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final message = Uri.encodeComponent("Hello, I'm interested in your ad.");
                final whatsappUrl = Uri.parse(
                  "https://wa.me/${adModel.contactPhone.isEmpty ? adModel.seller.phone : adModel.contactPhone}?text=$message"
                );

                if (await canLaunchUrl(whatsappUrl)) {
                  await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open WhatsApp')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Admin Statistics Card
class AdStatisticsCard extends StatelessWidget {
  const AdStatisticsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.analytics, color: AppColors.primaryColor, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    "Ad Statistics",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Statistics Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.visibility,
                  title: 'Views',
                  value: '2,456',
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.favorite,
                  title: 'Favorites',
                  value: '87',
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.phone,
                  title: 'Calls',
                  value: '34',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.chat,
                  title: 'Messages',
                  value: '52',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Divider
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
          
          const SizedBox(height: 20),
          
          // Ad Information
          const Text(
            'Ad Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.calendar_today, 'Posted Date', 'Oct 1, 2025'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.update, 'Last Updated', 'Oct 12, 2025'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.tag, 'Ad ID', '#AD-2025-10234'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.category, 'Category', 'SUV'),
          
          const SizedBox(height: 24),
          
          // Divider
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
          
          const SizedBox(height: 20),
          
          // Performance Metrics
          const Text(
            'Performance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildProgressMetric('View Rate', 0.78, '78%'),
          const SizedBox(height: 16),
          _buildProgressMetric('Engagement Rate', 0.42, '42%'),
          const SizedBox(height: 16),
          _buildProgressMetric('Response Rate', 0.65, '65%'),
          
          const SizedBox(height: 24),
          
          // Admin Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Ad'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.red, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressMetric(String label, double value, String percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              percentage,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}