import 'package:flutter/material.dart';

class BuildStatCard extends StatelessWidget {
  const BuildStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.imgUrl,
    this.onPressed,
  });

  final String title;
  final String value;
  final String imgUrl;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
    onTap: onPressed,
    child: Container(
      width: 160,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imgUrl, width: 40, height: 40),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
  }
}

// Widget buildStatCard(String title, String value, String imgUrl) {
//   return InkWell(
//     onTap: () {},
//     child: Container(
//       width: 160,
//       height: 140,
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue, width: 2),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(imgUrl, width: 40, height: 40),
//           Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
//           SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
