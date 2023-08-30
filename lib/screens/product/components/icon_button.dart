// import 'package:flutter/material.dart';
//
// import '../../../consts/colors.dart';
//
// class CustomIconButton extends StatelessWidget {
//   const CustomIconButton(
//       this.iconData, {
//         super.key,
//         required this.press,
//       });
//
//   final IconData iconData;
//   final GestureTapCallback press;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         height: 40,
//         width: 40,
//         child: ElevatedButton(
//           style: ButtonStyle(
//             elevation: MaterialStateProperty.resolveWith<double>((states) => 0),
//             padding:
//             MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
//             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//               RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(50),
//               ),
//             ),
//             backgroundColor: MaterialStateProperty.resolveWith<Color?>(
//                   (Set<MaterialState> states) {
//                 if (states.contains(MaterialState.pressed)) {
//                   return Colors.grey; // Color for pressed state
//                 }
//                 return Colors.white; // Default color
//               },
//             ),
//           ),
//           child: Icon(
//             iconData,
//             color: blackColor,
//           ),
//           onPressed: press,
//         ));
//   }
// }
