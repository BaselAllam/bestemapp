import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/fav_widget.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AdsDetailsScreen extends StatefulWidget {
  AdsDetailsScreen();

  @override
  State<AdsDetailsScreen> createState() => _AdsDetailsScreenState();
}

class _AdsDetailsScreenState extends State<AdsDetailsScreen> {

  String? selectedImg;

  int selectedTab = 0;

  @override
  void initState() {
    selectedImg = widget.coSpaceModel.imgs[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      body: ListView(
        children: [
          buildImagesSection(),
          buildUpperTitleSection(),
          buildTitleSection(),
          buildTabsSection(),
          selectedTab == 0 ? buildAboutView() : selectedTab == 1 ? buildGalleryView() : buildReviewsView()
        ],
      ),
    );
  }

  buildImagesSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      height: MediaQuery.of(context).size.height / 3.5,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(selectedImg!),
          fit: BoxFit.fill
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.whiteColor
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: AppColors.greyColor,
                  iconSize: 25.0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.whiteColor
                    ),
                    child: IconButton(
                      icon: Icon(Icons.share),
                      color: AppColors.greyColor,
                      iconSize: 25.0,
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.whiteColor
                    ),
                    child: FavButton()
                  ),
                ],
              )
            ],
          ),
          Container(
            height: 70,
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (int i = 0; i < 10; i++)
                InkWell(
                  onTap: () {
                    // selectedImg = 
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8XbaDblmK0KlEgSV1hI0-hlBddRQEW-OR5Q&s'),
                        fit: BoxFit.fill
                      )
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8XbaDblmK0KlEgSV1hI0-hlBddRQEW-OR5Q&s'),
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.darken
                          ),
                      ),
                  ),
                  alignment: Alignment.center,
                  child: Text('+10', style: AppFonts.miniFontWhiteColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildUpperTitleSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.all(5.0),
            child: Text(selectedLang[AppLangAssets.usedCondition]!, style: AppFonts.miniFontGreenColor),
          ),
          Text(
            '⭐ 4.9 ( 365 reviews )',
            style: AppFonts.subFontBlackColor,
          ),
        ],
      ),
    );
  }

  buildTitleSection() {
    return ListTile(
      title: Text('Mercdes', style: AppFonts.primaryFontBlackColor),
      subtitle: Text('address heliopolis', style: AppFonts.subFontGreyColor),
      trailing: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.greenColor
        ),
        child: IconButton(
          icon: Icon(Icons.location_on_outlined),
          color: AppColors.whiteColor,
          iconSize: 25.0,
          onPressed: () {},
        ),
      ),
    );
  }

  buildTabsSection() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              selectedTab = 0;
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                border: selectedTab != 0 ? Border() : Border(bottom: BorderSide(color: AppColors.greenColor))
              ),
              alignment: Alignment.center,
              child: Text('About', style: selectedTab == 0 ? AppFonts.priamryGreenFont : AppFonts.primaryNormalBlackFont),
            )
          ),
          InkWell(
            onTap: () {
              selectedTab = 1;
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                border: selectedTab != 1 ? Border() : Border(bottom: BorderSide(color: AppColors.greenColor))
              ),
              alignment: Alignment.center,
              child: Text('Gallery', style: selectedTab == 1 ? AppFonts.priamryGreenFont : AppFonts.primaryNormalBlackFont),
            )
          ),
          InkWell(
            onTap: () {
              selectedTab = 2;
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                border: selectedTab != 2 ? Border() : Border(bottom: BorderSide(color: AppColors.greenColor))
              ),
              alignment: Alignment.center,
              child: Text('Reviews', style: selectedTab == 2 ? AppFonts.priamryGreenFont : AppFonts.primaryNormalBlackFont),
            )
          ),
        ],
      ),
    );
  }

  buildGalleryView() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          for (int i = 0; i < widget.coSpaceModel.imgs.length; i++)
          InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(widget.coSpaceModel.imgs[i]),
                  fit: BoxFit.fill
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildAboutView() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.directions_walk_rounded, color: AppColors.greenColor),
                  Text(' 5 ', style: AppFonts.primaryNormalBlackFont),
                  Text('MIN', style: AppFonts.priamryGreyFont),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.greenColor),
                  Text(' 2.3 ', style: AppFonts.primaryNormalBlackFont),
                  Text('KM', style: AppFonts.priamryGreyFont),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.watch_later, color: AppColors.greenColor),
                  Text(' open', style: AppFonts.primaryNormalBlackFont),
                ],
              ),
            ],
          ),
          SizedBox(height: 30.0),
          ListTile(
            title: Text('Description', style: AppFonts.primaryNormalBlackFont),
            subtitle: Text(widget.coSpaceModel.bio, style: AppFonts.priamryGreyFont),
          ),
        ],
      ),
    );
  }

  buildReviewsView() {
    return Container(
      child: Column(
        children: [
          ListTile(
          title: Text(
            '⭐ 4.9 ( 365 reviews )',
            style: AppFonts.subBlackFont,
          ),
          trailing: CustomBtnWidget(title: 'Add Review', backgroundColor: AppColors.greenColor, textStyle: AppFonts.miniWhiteFont, size: Size(100, 30),
          onPress: () {},
          ),
        ),
          for (int i = 0; i < 10; i++)
          Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  minRadius: 40,
                  maxRadius: 40,
                  backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/44323531?v=4'),
                ),
                title: Text('Bassel Allam', style: AppFonts.primaryNormalBlackFont),
                subtitle: Text('a great workspace i enojoed there', style: AppFonts.priamryGreyFont),
              ),
              Divider(endIndent: 20, indent: 20, thickness: 0.3, color: AppColors.greyColor)
            ],
          )
        ],
      ),
    );
  }
}