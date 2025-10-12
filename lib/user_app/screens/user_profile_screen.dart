import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/error_widget.dart';
import 'package:bestemapp/shared/shared_widgets/field.dart';
import 'package:bestemapp/shared/shared_widgets/loading_spinner.dart';
import 'package:bestemapp/shared/shared_widgets/toaster.dart';
import 'package:bestemapp/shared/shared_widgets/view_password_widget.dart';
import 'package:bestemapp/shared/utils/app_assets.dart';
import 'package:bestemapp/user_app/logic/user_cubit.dart';
import 'package:bestemapp/user_app/logic/user_states.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool? isMale;

  bool isSecure = true;
  bool isEditable = false;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
    
    emailController.text = BlocProvider.of<UserCubit>(context).userModel!.email;
    phoneController.text = BlocProvider.of<UserCubit>(context).userModel!.phone;
    firstNameController.text = BlocProvider.of<UserCubit>(context).userModel!.firstName;
    lastNameController.text = BlocProvider.of<UserCubit>(context).userModel!.lastName;
    isMale = BlocProvider.of<UserCubit>(context).userModel!.isMale;
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              Text(
                selectedLang[AppLangAssets.chooseProfilePic]!,
                style: AppFonts.primaryFontBlackColor.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildImageSourceButton(
                      icon: Icons.camera_alt_rounded,
                      label: selectedLang[AppLangAssets.camera]!,
                      gradient: LinearGradient(
                        colors: [AppColors.primaryColor, AppColors.primaryColor.withOpacity(0.7)],
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        await _getImage(ImageSource.camera);
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildImageSourceButton(
                      icon: Icons.photo_library_rounded,
                      label: selectedLang[AppLangAssets.gallery]!,
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.purple.shade300],
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        await _getImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      );
    } catch (e) {
      Toaster.show(
        context,
        message: selectedLang[AppLangAssets.errorPickImg]!,
        type: ToasterType.error,
        position: ToasterPosition.top
      );
    }
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
        Toaster.show(
          context,
          message: selectedLang[AppLangAssets.imgSelectedSuccess]!,
          type: ToasterType.success,
          position: ToasterPosition.top
        );
      }
    } catch (e) {
      Toaster.show(
        context,
        message: selectedLang[AppLangAssets.errorPickImg]!,
        type: ToasterType.error,
        position: ToasterPosition.top
      );
    }
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: AppColors.whiteColor),
            SizedBox(height: 8),
            Text(
              label,
              style: AppFonts.primaryFontWhiteColor.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.whiteColor.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: BackBtn(),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                isEditable ? Icons.close_rounded : Icons.edit_rounded,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                setState(() {
                  isEditable = !isEditable;
                });
              },
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<UserCubit, UserStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetUserDataLoadingState) {
            return Center(child: CustomLoadingSpinner());
          } else if (state is GetUserDataErrorState || state is GetUserDataSomeThingWentWrongState) {
            return Center(child: CustomErrorWidget());
          } else {
            var userModel = BlocProvider.of<UserCubit>(context).userModel;
            return FadeTransition(
              opacity: _fadeAnimation,
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      height: 320,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryColor.withOpacity(0.8),
                            AppColors.primaryColor.withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: CirclePatternPainter(),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 60),
                                ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.3),
                                              Colors.white.withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 150,
                                        width: 150,
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.whiteColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 24,
                                              offset: Offset(0, 12),
                                            ),
                                          ],
                                        ),
                                        child: ClipOval(
                                          child: selectedImage != null
                                              ? Image.file(
                                                  selectedImage!,
                                                  fit: BoxFit.cover,
                                                )
                                              : userModel!.profilePic.isEmpty
                                                  ? Image.asset(
                                                      AppAssets.noPPIcon,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      userModel.profilePic,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context, child, progress) {
                                                        if (progress == null) return child;
                                                        return Center(child: CustomLoadingSpinner());
                                                      },
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Image.asset(
                                                          AppAssets.noPPIcon,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    ),
                                        ),
                                      ),
                                      if (isEditable)
                                        Positioned(
                                          bottom: 5,
                                          right: 5,
                                          child: InkWell(
                                            onTap: _pickImage,
                                            borderRadius: BorderRadius.circular(24),
                                            child: Container(
                                              height: 48,
                                              width: 48,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors.primaryColor,
                                                    AppColors.primaryColor.withOpacity(0.8),
                                                  ],
                                                ),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColors.whiteColor,
                                                  width: 3,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.primaryColor.withOpacity(0.4),
                                                    blurRadius: 12,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                Icons.camera_alt_rounded,
                                                color: AppColors.whiteColor,
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '${userModel!.firstName} ${userModel.lastName}',
                                  style: AppFonts.primaryFontWhiteColor.copyWith(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    userModel.email,
                                    style: AppFonts.primaryFontWhiteColor.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: Offset(0, -30),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 32, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    selectedLang[AppLangAssets.profileData]!,
                                    style: AppFonts.primaryFontBlackColor.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              _buildAnimatedField(
                                title: selectedLang[AppLangAssets.firstName]!,
                                controller: firstNameController,
                                icon: Icons.person_outline_rounded,
                                delay: 0,
                              ),
                              SizedBox(height: 16),
                              _buildAnimatedField(
                                title: selectedLang[AppLangAssets.lastName]!,
                                controller: lastNameController,
                                icon: Icons.person_outline_rounded,
                                delay: 50,
                              ),
                              SizedBox(height: 16),
                              _buildAnimatedField(
                                title: selectedLang[AppLangAssets.phoneNumber]!,
                                controller: phoneController,
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.number,
                                formatters: [FilteringTextInputFormatter.digitsOnly],
                                delay: 100,
                              ),
                              SizedBox(height: 16),
                              _buildAnimatedField(
                                title: selectedLang[AppLangAssets.email]!,
                                controller: emailController,
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                delay: 150,
                              ),
                              SizedBox(height: 16),
                              buildGenderSelector(delay: 175),
                              SizedBox(height: 32),
                              BlocConsumer<UserCubit, UserStates>(
                                listener: (context, state) {
                                  if (state is UpdateUserDataErrorState) {
                                    Toaster.show(
                                      context,
                                      message: state.errMsg,
                                      type: ToasterType.error,
                                      position: ToasterPosition.top
                                    );
                                  } else if (state is UpdateUserDataSomeThingWentWrongState) {
                                    Toaster.show(
                                      context,
                                      message: selectedLang[AppLangAssets.someThingWentWrong]!,
                                      type: ToasterType.error,
                                      position: ToasterPosition.top
                                    );
                                  } else if (state is UpdateUserDataSuccessState) {
                                    setState(() {
                                      isEditable = false;
                                    });
                                    Toaster.show(
                                      context,
                                      message: selectedLang[AppLangAssets.profileUpdatedSuccess]!,
                                      type: ToasterType.success,
                                      position: ToasterPosition.top
                                    );
                                  }
                                },
                                builder: (context, state) => AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: isEditable ? [
                                      BoxShadow(
                                        color: AppColors.primaryColor.withOpacity(0.3),
                                        blurRadius: 16,
                                        offset: Offset(0, 8),
                                      ),
                                    ] : [],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: state is UpdateUserDataLoadingState ? null : () {
                                      if (isEditable) {
                                        BlocProvider.of<UserCubit>(context).updateUserData(
                                          newFirstName: firstNameController.text,
                                          newLastName: lastNameController.text,
                                          newPhone: '${phoneController.text}',
                                          newEmail: emailController.text,
                                          newProfilePicture: selectedImage,
                                          newisAcceptNotification: userModel.isAcceptNotification,
                                          newIsMale: isMale!
                                        );
                                      } else {
                                        setState(() {
                                          isEditable = true;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isEditable
                                          ? AppColors.primaryColor
                                          : Colors.grey[300],
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: state is UpdateUserDataLoadingState
                                        ? SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                AppColors.whiteColor,
                                              ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                isEditable ? Icons.save_rounded : Icons.edit_rounded,
                                                color: isEditable
                                                    ? AppColors.whiteColor
                                                    : Colors.grey[600],
                                                size: 22,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                isEditable
                                                    ? selectedLang[AppLangAssets.save]!
                                                    : selectedLang[AppLangAssets.edit]!,
                                                style: TextStyle(
                                                  color: isEditable
                                                      ? AppColors.whiteColor
                                                      : Colors.grey[600],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildAnimatedField({
    required String title,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter> formatters = const [],
    bool isPassword = false,
    int delay = 0,
  }) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isEditable
                      ? AppColors.primaryColor.withOpacity(0.3)
                      : Colors.grey[200]!,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isEditable
                        ? AppColors.primaryColor.withOpacity(0.08)
                        : Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: authField(
                title: title,
                controller: controller,
                textInputAction: TextInputAction.done,
                enabled: isEditable,
                keyBoardType: keyboardType,
                formaters: formatters,
                validatorMethod: (v) {},
                inputStyle: AppFonts.subFontGreyColor.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                fillColor: AppColors.whiteColor,
                inputTitle: title,
                obsecure: isPassword ? isSecure : false,
                suffix: isPassword ? buildPasswordToggle(isSecure, () {
                  setState(() {
                    isSecure = !isSecure;
                  });
                }) : SizedBox(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildGenderSelector({int delay = 0}) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isEditable
                      ? AppColors.primaryColor.withOpacity(0.3)
                      : Colors.grey[200]!,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isEditable
                        ? AppColors.primaryColor.withOpacity(0.08)
                        : Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedLang[AppLangAssets.gender]!,
                    style: AppFonts.subFontBlackColor.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGenderOption(
                          label: selectedLang[AppLangAssets.male]!,
                          icon: Icons.male_rounded,
                          value: true,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildGenderOption(
                          label: selectedLang[AppLangAssets.female]!,
                          icon: Icons.female_rounded,
                          value: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenderOption({
    required String label,
    required IconData icon,
    required bool value,
  }) {
    final isSelected = isMale == value;
    return InkWell(
      onTap: isEditable
          ? () {
              setState(() {
                isMale = value;
              });
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.15),
                    AppColors.primaryColor.withOpacity(0.08),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryColor : Colors.grey[500],
              size: 28,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryColor : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CirclePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.2, size.height * 0.3),
        50.0 + (i * 30),
        paint,
      );
    }

    for (int i = 0; i < 2; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.7),
        40.0 + (i * 25),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}