// import 'dart:io';
// import 'package:flutter/material.dart';
//
// class ProfileWidget extends StatelessWidget {
//   final String imagePath;
//   final VoidCallback onClicked;
//
//   const ProfileWidget ({
//     Key key,
//     this.imagePath,
//     this.onClicked,
//
// }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     final color = Theme.of(context).colorScheme.primary;
//     return Center(
//       child: Stack(
//           children:[
//             buildImage(),
//             Positioned(
//               bottom: 0,
//                 right: 4,
//                 child: buildEditIcon(color)),
//       ],
//       ),
//     );
//   }
//
//   Widget buildImage() {
//     final image = NetworkImage(imagePath);
//     return ClipOval(
//
//       child: Material(
//         color: Colors.transparent,
//         child: Ink.image(
//           image:image,
//           fit: BoxFit.cover,
//           width: 150,
//           height: 150,
//           child: InkWell(onTap: onClicked),
//         ),
//       ),
//     );
//   }
//
//   Widget buildEditIcon(Color color) => buildCircle(
//     color: Colors.white,
//     all: 3,
//     child: buildCircle(
//     color: color,
//     all: 8,
//     child: Icon(
//       Icons.edit,
//       color: Colors.white,
//       size:20
//     ),
//   ),
//   );
//
//   Widget buildCircle({
//      Widget child,
//      double all,
//      Color color,
// }) =>
//       ClipOval(
//         child: Container(
//           color: color,
//           padding: EdgeInsets.all(all),
//           child: child,
//         ),
//       );
// }