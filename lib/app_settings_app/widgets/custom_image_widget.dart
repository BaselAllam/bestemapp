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
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.grey[400]!,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            SizedBox(height: 8),
            Text(
              'Image unavailable',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      fadeInDuration: Duration(milliseconds: 300),
      fadeOutDuration: Duration(milliseconds: 200),
    );
  }
}