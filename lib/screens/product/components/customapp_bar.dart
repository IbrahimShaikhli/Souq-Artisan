// import 'package:ecommerce_app/screens/product/components/icon_button.dart';
// import 'package:flutter/material.dart';
// import 'package:ecommerce_app/screens/screens.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSize {
//   final double rating;
//
//   const CustomAppBar({super.key, required this.rating});
//   @override
//   Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             CustomIconButton(
//               Icons.arrow_back,
//               press: () => Navigator.pop(context),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(15)),
//               child: Row(
//                 children: [
//                   Text(
//                     rating.toString(),
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(
//                     child: Icon(Icons.star_border_outlined),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   // TODO: implement child
//   Widget get child => throw UnimplementedError();
//
// }
