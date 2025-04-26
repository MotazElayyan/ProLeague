// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:grad_project/models/newsItem.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<NewsItem?> getNewsItem(
//     String id,
//     String category,
//     String content,
//     String date,
//     String imageUrl,
//     String title,
//   ) async {
//     try {
//       await _firestore.collection('News').get();
//       NewsItem newNewsItem = NewsItem(Id: id, Title: Title, ImgUrl: ImgUrl, Category: Category, author: author, Time: Time, link: link)
//     }
//     catch (e) {
//       print("Error fetching user data: $e");
//       return null;
//     }
//   }
// }
