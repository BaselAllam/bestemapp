import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/booking_widget.dart';
import 'package:bestemapp/shared/shared_widgets/notification_btn.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';


class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with TickerProviderStateMixin {

  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.ofWhiteColor,
        title: Text(selectedLang[AppLangAssets.navBarBooking]!, style: AppFonts.primaryFontBlackColor),
        actions: [NotificationButton()],
        bottom: PreferredSize(
          preferredSize: Size(0, 30),
          child: TabBar(
            indicatorColor: AppColors.primaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            unselectedLabelStyle: AppFonts.subFontGreyColor,
            labelStyle: AppFonts.subFontBlackColor,
            controller: tabController,
            tabs: [
              Text(selectedLang[AppLangAssets.requested]!),
              Text(selectedLang[AppLangAssets.otherRequest]!),
            ],
          )
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          RequestedBookingTab(),
          OtherRequestsBookingTab()
        ],
      )
      
      
    );
  }
}


class RequestedBookingTab extends StatefulWidget {
  const RequestedBookingTab({super.key});

  @override
  State<RequestedBookingTab> createState() => _RequestedBookingTabState();
}

class _RequestedBookingTabState extends State<RequestedBookingTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (int i = 0; i < 5; i++)
        BookingWidget(isHomeView: false)
      ],
    );
  }
}


class OtherRequestsBookingTab extends StatefulWidget {
  const OtherRequestsBookingTab({super.key});

  @override
  State<OtherRequestsBookingTab> createState() => _OtherRequestsBookingTabState();
}

class _OtherRequestsBookingTabState extends State<OtherRequestsBookingTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (int i = 0; i < 5; i++)
        BookingWidget(isHomeView: false, isOtherRequest: true)
      ],
    );
  }
}