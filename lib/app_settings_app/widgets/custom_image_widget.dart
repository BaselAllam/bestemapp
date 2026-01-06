import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_widgets/loading_spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class CustomImageWidget extends StatefulWidget {
  final String img;
  final double width;
  final double height;
  final BoxFit fit;
  const CustomImageWidget({this.fit = BoxFit.cover, this.width = 50, this.height= 50, required this.img});

  @override
  State<CustomImageWidget> createState() => Custom_ImageWidgetState();
}

class Custom_ImageWidgetState extends State<CustomImageWidget> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.img,
      fit: widget.fit,
      height: widget.height,
      width: widget.width,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: widget.fit,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: Center(
          child: CustomLoadingSpinner()
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.image_not_supported_outlined,
        size: 30,
        color: Colors.grey[400],
      ),
      fadeInDuration: Duration(milliseconds: 300),
      fadeOutDuration: Duration(milliseconds: 200),
    );
  }
}