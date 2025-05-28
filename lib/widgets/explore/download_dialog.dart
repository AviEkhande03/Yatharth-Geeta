import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../../utils/utils.dart';

void downloadAndShareImage(String imageUrl, BuildContext context) async {
  Utils().showLoader();
  await downloadImage(imageUrl, context);
  Get.back();
}

// void downloadAndShareImage(String imageUrl, BuildContext context) async {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         // title: const Text('Downloading...'),
//         content: FutureBuilder(
//           future: downloadImage(imageUrl, context),
//           builder: (context, snapshot) {
//             Utils().showLoader();
//             if (snapshot.connectionState == ConnectionState.done) {
//               Get.back();
//               return Text(
//                 "Successfully Shared",
//                 style: kTextStylePoppinsMedium,
//               );
//             } else {
//               Get.back();
//               return SizedBox.shrink();
//             }
//           },
//         ),
//       );
//     },
//   );
// }

Future<File> downloadImage(String imageUrl, BuildContext context) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    final directory = Directory.systemTemp;
    final file = File('${directory.path}/image.png');
    await file.writeAsBytes(response.bodyBytes);
    print(file);
    shareImage(file, context);
    return file;
  } else {
    throw Exception('Failed to download image');
  }
}

void shareImage(File imageFile, BuildContext context) {
  Share.shareXFiles([XFile(imageFile.path)], subject: "Test");
}
