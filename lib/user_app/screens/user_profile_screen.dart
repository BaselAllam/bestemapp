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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedLang[AppLangAssets.chooseProfilePic]!,
                style: AppFonts.primaryFontBlackColor.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSourceButton(
                    icon: Icons.camera_alt,
                    label: selectedLang[AppLangAssets.camera]!,
                    onTap: () async {
                      Navigator.pop(context);
                      await _getImage(ImageSource.camera);
                    },
                  ),
                  _buildImageSourceButton(
                    icon: Icons.photo_library,
                    label: selectedLang[AppLangAssets.gallery]!,
                    onTap: () async {
                      Navigator.pop(context);
                      await _getImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    } catch (e) {
      Toaster.show(
        context,
        message: selectedLang[AppLangAssets.errorPickImg]!,
        type: ToasterType.success,
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppColors.primaryColor),
            SizedBox(height: 8),
            Text(label, style: AppFonts.subFontGreyColor),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          selectedLang[AppLangAssets.myProfile]!,
          style: AppFonts.primaryFontBlackColor,
        ),
        leading: BackBtn(),
        actions: [
          IconButton(
            icon: Icon(
              isEditable ? Icons.save : Icons.edit,
              color: AppColors.primaryColor,
            ),
            onPressed: () {
              setState(() {
                isEditable = !isEditable;
              });
              if (!isEditable) {
                Toaster.show(
                  context,
                  message: selectedLang[AppLangAssets.profileUpdatedSuccess]!,
                  type: ToasterType.success,
                  position: ToasterPosition.top
                );
              }
            },
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
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primaryColor.withOpacity(0.1),
                            AppColors.ofWhiteColor,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Stack(
                            children: [
                              Hero(
                                tag: 'profile_pic',
                                child: Container(
                                  height: 140,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryColor.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: AppColors.whiteColor,
                                      width: 4,
                                    ),
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
                              ),
                              if (isEditable)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: _pickImage,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: AppColors.whiteColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            '${userModel!.firstName} ${userModel.lastName}',
                            style: AppFonts.primaryFontBlackColor.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            userModel.email,
                            style: AppFonts.subFontGreyColor.copyWith(fontSize: 14),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedLang[AppLangAssets.profileData]!,
                            style: AppFonts.primaryFontBlackColor.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildAnimatedField(
                            title: selectedLang[AppLangAssets.firstName]!,
                            controller: firstNameController,
                            icon: Icons.person_outline,
                            delay: 0,
                          ),
                          SizedBox(height: 16),
                          _buildAnimatedField(
                            title: selectedLang[AppLangAssets.lastName]!,
                            controller: lastNameController,
                            icon: Icons.person_outline,
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
                          SizedBox(height: 40),
                          // Action Button
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
                              height: 56,
                              child: ElevatedButton(
                                onPressed: state is UpdateUserDataLoadingState ? () {} : () {
                                  setState(() {
                                    isEditable = !isEditable;
                                  });
                                  if (!isEditable) {
                                    BlocProvider.of<UserCubit>(context).updateUserData(
                                      newFirstName: firstNameController.text,
                                      newLastName: lastNameController.text,
                                      newPhone: '+${phoneController.text}',
                                      newEmail: emailController.text,
                                      newProfilePicture: selectedImage,
                                      newisAcceptNotification: userModel.isAcceptNotification,
                                      newIsMale: isMale!
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isEditable
                                      ? AppColors.primaryColor
                                      : AppColors.greyColor,
                                  elevation: isEditable ? 8 : 2,
                                  shadowColor: isEditable
                                      ? AppColors.primaryColor.withOpacity(0.5)
                                      : Colors.black.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isEditable ? Icons.save : Icons.edit,
                                      color: AppColors.whiteColor,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      isEditable
                                          ? selectedLang[AppLangAssets.save]! : state is UpdateUserDataLoadingState ? selectedLang[AppLangAssets.loading]! 
                                          : selectedLang[AppLangAssets.edit]!,
                                      style: AppFonts.primaryFontWhiteColor.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
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
      duration: Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
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
                inputStyle: AppFonts.subFontGreyColor,
                fillColor: AppColors.whiteColor,
                inputTitle: title,
                obsecure: isPassword ? isSecure : false,
                suffix: isPassword ? buildPasswordToggle(isSecure, () {setState(() {
                  isSecure = !isSecure;
                });}) : SizedBox(),
              ),
            ),
          ),
        );
      },
    );
  }

Widget buildGenderSelector({int delay = 0}) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedLang[AppLangAssets.gender]!,
                    style: AppFonts.subFontBlackColor
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGenderOption(
                          label: selectedLang[AppLangAssets.male]!,
                          icon: Icons.male,
                          value: true,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildGenderOption(
                          label: selectedLang[AppLangAssets.female]!,
                          icon: Icons.female,
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
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryColor : Colors.grey[600],
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryColor : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

}