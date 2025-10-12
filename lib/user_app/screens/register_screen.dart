import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/logo_container.dart';
import 'package:bestemapp/shared/shared_widgets/phone_input_field.dart';
import 'package:bestemapp/shared/shared_widgets/toaster.dart';
import 'package:bestemapp/shared/shared_widgets/view_password_widget.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:bestemapp/user_app/logic/user_cubit.dart';
import 'package:bestemapp/user_app/logic/user_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isSecure = true;
  bool? isMale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: LogoContainer(size: Size(MediaQuery.of(context).size.width / 2.5, 150))),
                Text(
                  selectedLang[AppLangAssets.register]!,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedLang[AppLangAssets.firstName]!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              hintText: selectedLang[AppLangAssets.enterFirstName],
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedLang[AppLangAssets.lastName]!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              hintText: selectedLang[AppLangAssets.enterLastName],
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  selectedLang[AppLangAssets.email]!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'your.email@example.com',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 40),
                PhoneInputField(controller: _phoneController),
                const SizedBox(height: 40),
                buildGenderSelector(delay: 175),
                const SizedBox(height: 24),
                Text(
                  selectedLang[AppLangAssets.password]!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: isSecure,
                  decoration: InputDecoration(
                    hintText: selectedLang[AppLangAssets.enterUrPassword],
                    hintStyle: TextStyle(color: Colors.grey),
                    suffix: buildPasswordToggle(isSecure, () {setState(() {
                      isSecure = !isSecure;
                    });})
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  selectedLang[AppLangAssets.confirmPassword]!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: isSecure,
                  decoration: InputDecoration(
                    hintText: selectedLang[AppLangAssets.enterUrPassword],
                    hintStyle: TextStyle(color: Colors.grey),
                    suffix: buildPasswordToggle(isSecure, () {setState(() {
                      isSecure = !isSecure;
                    });})
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: BlocConsumer<UserCubit, UserStates>(
                    listener: (context, state) async {
                      if (state is RegisterErrorState) {
                        Toaster.show(
                          context,
                          message: state.errMsg,
                          position: ToasterPosition.top,
                          type: ToasterType.error
                        );
                      } else if (state is RegisterSomeThingWentWrongState) {
                        Toaster.show(
                          context,
                          message: selectedLang[AppLangAssets.someThingWentWrong]!,
                          position: ToasterPosition.top,
                          type: ToasterType.error
                        );
                      } else if (state is RegisterSuccessState) {
                        Toaster.show(
                          context,
                          message: selectedLang[AppLangAssets.registerSuccess]!,
                          position: ToasterPosition.top,
                          type: ToasterType.success
                        );
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.pop(context);
                      }
                    },
                    builder: (context, state) => ElevatedButton(
                      onPressed: () {
                        if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty || _phoneController.text.isEmpty || _emailController.text.isEmpty || isMale == null) {
                          Toaster.show(
                            context,
                            message: selectedLang[AppLangAssets.fieldsRequired]!,
                            position: ToasterPosition.top,
                            type: ToasterType.error
                          );
                        } else if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty || _passwordController.text.length < 8 || _passwordController.text != _confirmPasswordController.text) {
                          Toaster.show(
                            context,
                            message: selectedLang[AppLangAssets.passwordNotMatch]!,
                            position: ToasterPosition.top,
                            type: ToasterType.error
                          );
                        } else {
                          BlocProvider.of<UserCubit>(context).register(
                            email: _emailController.text,
                            password: _passwordController.text,
                            confirmPassword: _confirmPasswordController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            phone: '+${_phoneController.text}',
                            country: BlocProvider.of<AppSettingsCubit>(context).countries[0].id,
                            isMale: isMale!
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        selectedLang[AppLangAssets.createAccount]!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
      onTap: () {
        setState(() {
          isMale = value;
        });
      },
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