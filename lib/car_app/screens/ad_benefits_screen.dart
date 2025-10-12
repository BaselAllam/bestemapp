import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/car_app/screens/create_car_ad_screen.dart';
import 'package:bestemapp/shared/utils/app_assets.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarAdBenefitsScreen extends StatefulWidget {
  const CarAdBenefitsScreen({Key? key}) : super(key: key);

  @override
  State<CarAdBenefitsScreen> createState() => _CarAdBenefitsScreenState();
}

class _CarAdBenefitsScreenState extends State<CarAdBenefitsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(selectedLang[AppLangAssets.sellWithBestem]!, style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Section
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primaryColor,
                                AppColors.primaryColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(AppAssets.bestemLogo, height: 100, width: 100,),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                selectedLang[AppLangAssets.sellFaster]!,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                selectedLang[AppLangAssets.joinThousand]!,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      selectedLang[AppLangAssets.noHiddenFee]!,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.95),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Statistics
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                '${BlocProvider.of<CarCubit>(context).usersCount}+',
                                selectedLang[AppLangAssets.users]!,
                                Icons.people_rounded,
                                const Color(0xFF10B981),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                BlocProvider.of<CarCubit>(context).carAdsCount.toString(),
                                selectedLang[AppLangAssets.ads]!,
                                Icons.directions_car,
                                const Color(0xFF3B82F6),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        Text(
                          selectedLang[AppLangAssets.whyChooseUs]!,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Benefits List
                        _buildBenefitItem(
                          icon: Icons.visibility_rounded,
                          title: selectedLang[AppLangAssets.benefitVisibilityTitle]!,
                          description: selectedLang[AppLangAssets.benefitVisibilityDescription]!,
                          color: const Color(0xFF8B5CF6),
                        ),
                        
                        _buildBenefitItem(
                          icon: Icons.verified_user_rounded,
                          title: selectedLang[AppLangAssets.benefitVerifiedTitle]!,
                          description: selectedLang[AppLangAssets.benefitVerifiedDescription]!,
                          color: const Color(0xFF10B981),
                        ),
                        
                        _buildBenefitItem(
                          icon: Icons.photo_camera_rounded,
                          title: selectedLang[AppLangAssets.benefitPresentationTitle]!,
                          description: selectedLang[AppLangAssets.benefitPresentationDescription]!,
                          color: const Color(0xFFF59E0B),
                        ),
                        
                        _buildBenefitItem(
                          icon: Icons.notifications_active_rounded,
                          title: selectedLang[AppLangAssets.benefitNotificationsTitle]!,
                          description: selectedLang[AppLangAssets.benefitNotificationsDescription]!,
                          color: const Color(0xFFEF4444),
                        ),
                        
                        _buildBenefitItem(
                          icon: Icons.price_check_rounded,
                          title: selectedLang[AppLangAssets.benefitPricingTitle]!,
                          description: selectedLang[AppLangAssets.benefitPricingDescription]!,
                          color: const Color(0xFF3B82F6),
                        ),
                        
                        _buildBenefitItem(
                          icon: Icons.support_agent_rounded,
                          title: selectedLang[AppLangAssets.benefitSupportTitle]!,
                          description: selectedLang[AppLangAssets.benefitSupportDescription]!,
                          color: const Color(0xFFEC4899),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Process Steps
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.timeline_rounded, color: AppColors.primaryColor, size: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    selectedLang[AppLangAssets.simpleSteps]!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildProcessStep('1', selectedLang[AppLangAssets.firstSimpleStepTitle]!, selectedLang[AppLangAssets.firstSimpleStepSubTitle]!, true),
                              _buildProcessStep('2', selectedLang[AppLangAssets.secondSimpleStepTitle]!, selectedLang[AppLangAssets.secondSimpleStepSubTitle]!, true),
                              _buildProcessStep('3', selectedLang[AppLangAssets.thirdSimpleStepTitle]!, selectedLang[AppLangAssets.thirdSimpleStepSubTitle]!, false),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Trust Indicators
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade50,
                                Colors.purple.shade50,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.security_rounded, size: 48, color: Color(0xFF3B82F6)),
                              const SizedBox(height: 12),
                              Text(
                                selectedLang[AppLangAssets.yourPrivacyIsProtected]!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                selectedLang[AppLangAssets.yourPrivacyIsProtectedSubtitle]!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Bottom CTA
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to CarAdCreationPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CarAdCreationPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: AppColors.primaryColor,
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedLang[AppLangAssets.createYourAdNow]!,
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 22, color: AppColors.whiteColor,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    selectedLang[AppLangAssets.itTakesOnlyMinutes]!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessStep(String number, String title, String description, bool hasLine) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (hasLine)
                  Container(
                    width: 2,
                    height: 40,
                    color: AppColors.primaryColor.withOpacity(0.3),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  if (hasLine) const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}