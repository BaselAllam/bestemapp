import 'package:bestemapp/car_app/screens/car_ads_details_screen.dart';
import 'package:bestemapp/shared/shared_widgets/fav_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class AdWidget extends StatefulWidget {
//   final double imgHieght;
//   final bool isAdminView;
//   AdWidget({required this.imgHieght, this.isAdminView = false});

//   @override
//   State<AdWidget> createState() => _AdWidgetState();
// }

// class _AdWidgetState extends State<AdWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(context, CupertinoPageRoute(builder: (_) => CarDetailScreen()));
//       },
//       child: Container(
//         width: MediaQuery.of(context).size.width / 1.2,
//         margin: EdgeInsets.all(10.0),
//         decoration: BoxDecoration(
//           color: AppColors.whiteColor,
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         child: Column(
//           children: [
//             ListTile(
//               leading: Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: AppColors.greyColor, width: 0.5)
//                 ),
//                 padding: EdgeInsets.all(3.0),
//                 child: CircleAvatar(
//                   minRadius: 20,
//                   maxRadius: 20,
//                   backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8XbaDblmK0KlEgSV1hI0-hlBddRQEW-OR5Q&s'),
//                 ),
//               ),
//               title: Text('Mercedes AMG for Sale', style: AppFonts.subFontBlackColor),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text('E300', style: AppFonts.subFontPrimaryColor),
//                       Text(' - 1K ${selectedLang[AppLangAssets.adViews]}', style: AppFonts.miniFontGreyColor),
//                       Text(' - Acive', style: AppFonts.miniFontGreenColor),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Text('Cairo, Nasr City ', style: AppFonts.miniFontGreyColor),
//                       Text(' - 12-12-2024', style: AppFonts.miniFontGreyColor),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: widget.imgHieght,
//               margin: EdgeInsets.all(10.0),
//               decoration: BoxDecoration(
//                 color: AppColors.whiteColor,
//                 borderRadius: BorderRadius.circular(20.0),
//                 image: DecorationImage(
//                   image: NetworkImage('https://images.pexels.com/photos/112460/pexels-photo-112460.jpeg?auto=compress&cs=tinysrgb&w=600'),
//                   fit: BoxFit.fill
//                 )
//               ),
//               alignment: Alignment.topCenter,
//               padding: EdgeInsets.all(5.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ShareBtn(),
//                   if (widget.isAdminView)
//                   Container(
//                     decoration: BoxDecoration(
//                       color: AppColors.whiteColor,
//                       shape: BoxShape.circle
//                     ),
//                     child: IconButton(
//                       icon: Icon(Icons.edit),
//                       color: AppColors.greyColor,
//                       iconSize: 15.0,
//                       onPressed: () {},
//                     ),
//                   ),
//                   if (!widget.isAdminView)
//                   FavButton(),
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 sepcsItem('25000 KM'),
//                 sepcsItem('2022'),
//                 sepcsItem('Used'),
//                 sepcsItem('Manual'),
//               ],
//             ),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 sepcsItem('Air Bag'),
//                 sepcsItem('ABS'),
//                 sepcsItem('EBD'),
//                 sepcsItem('Sensors'),
//               ],
//             ),
//             Container(
//               margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
//               decoration: BoxDecoration(
//                 border: Border(left: BorderSide(color: AppColors.primaryColor, width: 5))
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Image.asset(AppAssets.moneyIcon, height: 30.0, width: 30.0),
//                       Text('  25000 EGP', style: AppFonts.primaryFontPrimaryColor),
//                     ],
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(left: 10.0, right: 10.0),
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryColor,
//                       borderRadius: BorderRadius.circular(10.0)
//                     ),
//                     alignment: Alignment.center,
//                     padding: EdgeInsets.all(5.0),
//                     child: Text('Negotiable 👌🏻', style: AppFonts.miniFontWhiteColor)
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   sepcsItem(String title) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.ofWhiteColor,
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       margin: EdgeInsets.all(5.0),
//       height: 30.0,
//       width: title.length * 12,
//       alignment: Alignment.center,
//       child: Text(title, style: AppFonts.miniFontGreyColor),
//     );
//   }
// }




class CarAdWidget extends StatefulWidget {
  Map<String, dynamic> car;
  CarAdWidget({required this.car});

  @override
  State<CarAdWidget> createState() => _CarAdWidgetState();
}

class _CarAdWidgetState extends State<CarAdWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
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
          Navigator.push(context, CupertinoPageRoute(builder: (_) => CarDetailScreen()));
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
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Image.network(
                      widget.car['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.directions_car, size: 64, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (widget.car['isFeatured'])
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange[600],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'FEATURED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
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
                    child: FavButton()
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
                          widget.car['title'],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (widget.car['isVerified'])
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
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.car['price'].toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(Icons.calendar_today, '${widget.car['year']}'),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.speed, '${widget.car['mileage']} mi'),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.local_gas_station, widget.car['fuelType']),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        widget.car['location'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.car['condition'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
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
                        Icon(
                          widget.car['seller'] == 'Private Seller' 
                              ? Icons.person_outline 
                              : Icons.store_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.car['seller'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'View Details',
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
          ],
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