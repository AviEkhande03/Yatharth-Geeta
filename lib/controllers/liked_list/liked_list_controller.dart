// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:yatharthageeta/const/constants/constants.dart';
// import 'package:yatharthageeta/models/home/audiobooks_model.dart';
// import 'package:yatharthageeta/models/home/ebooks_model.dart';
// import 'package:yatharthageeta/models/home/videos_model.dart';

// class LikedListController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   var sortList = [];

//   late TabController tabController;
//   var groupValue = "Alphabetically ( A-Z )".obs;
//   var tabIndex = 0.obs;
//   @override
//   void onInit() {
//     tabController = TabController(length: 3, vsync: this);

//     sortList = [
//       {
//         "title": "Alphabetically ( A-Z )".tr,
//         "value": "Alphabetically ( A-Z )",
//         "groupValue": groupValue
//       },
//       {
//         "title": "Alphabetically ( Z-A )".tr,
//         "value": "Alphabetically ( Z-A )",
//         "groupValue": groupValue
//       },
//       {
//         "title": "Recent".tr,
//         "value": "Recent",
//         "groupValue": groupValue,
//       },
//     ];
//     super.onInit();
//   }

//   var searchController = TextEditingController();

//   RxString selectedLikedListTab = 'Audio'.obs;

//   final List<AudioBooksModel> audioBooksDummyList = [
//     AudioBooksModel(
//       audioBookImgUrl: 'assets/images/liked_list/audio_cover1.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       language: 'Hindi',
//       duration: '30 mins 20 sec',
//       viewsCount: 32000,
//     ),
//     AudioBooksModel(
//       audioBookImgUrl: 'assets/images/liked_list/audio_cover2.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       language: 'Hindi',
//       duration: '30 mins 20 sec',
//       viewsCount: 32000,
//     ),
//     AudioBooksModel(
//       audioBookImgUrl: 'assets/images/liked_list/audio_cover3.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       language: 'Hindi',
//       duration: '30 mins 20 sec',
//       viewsCount: 32000,
//     ),
//     AudioBooksModel(
//       audioBookImgUrl: 'assets/images/liked_list/audio_cover4.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       language: 'Hindi',
//       duration: '30 mins 20 sec',
//       viewsCount: 32000,
//     ),
//     AudioBooksModel(
//       audioBookImgUrl: 'assets/images/liked_list/audio_cover1.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       language: 'Hindi',
//       duration: '30 mins 20 sec',
//       viewsCount: 32000,
//     ),
//     AudioBooksModel(
//       audioBookImgUrl: 'assets/images/liked_list/audio_cover2.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       language: 'Hindi',
//       duration: '30 mins 20 sec',
//       viewsCount: 32000,
//     ),
//     AudioBooksModel(
//       audioBookImgUrl: 'assets/images/liked_list/audio_cover3.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       language: 'Hindi',
//       duration: '30 mins 20 sec',
//       viewsCount: 32000,
//     ),
//     AudioBooksModel(
//       audioBookImgUrl: 'assets/images/liked_list/audio_cover4.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       language: 'Hindi',
//       duration: '30 mins 20 sec',
//       viewsCount: 32000,
//     ),
//   ];
//   final List<EbooksModel> ebooksDummyList = [
//     EbooksModel(
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover1.png',
//       langauge: 'Hindi',
//       author: 'Swami Adganand Maharaj',
//       favoriteFlag: 0,
//       views: 32000,
//       pagesCount: 500,
//       desription: Constants.ebookDummyDesc,
//       chaptersCount: 18,
//       versesCount: 700,
//     ),
//     EbooksModel(
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover2.png',
//       langauge: 'Hindi',
//       author: 'Swami Adganand Maharaj',
//       favoriteFlag: 0,
//       views: 32000,
//       pagesCount: 500,
//       desription: Constants.ebookDummyDesc,
//       chaptersCount: 18,
//       versesCount: 700,
//     ),
//     EbooksModel(
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover3.png',
//       langauge: 'Hindi',
//       author: 'Swami Adganand Maharaj',
//       favoriteFlag: 0,
//       views: 32000,
//       pagesCount: 500,
//       desription: Constants.ebookDummyDesc,
//       chaptersCount: 18,
//       versesCount: 700,
//     ),
//     EbooksModel(
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover4.png',
//       langauge: 'Hindi',
//       author: 'Swami Adganand Maharaj',
//       favoriteFlag: 0,
//       views: 32000,
//       pagesCount: 500,
//       desription: Constants.ebookDummyDesc,
//       chaptersCount: 18,
//       versesCount: 700,
//     ),
//     EbooksModel(
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover5.png',
//       langauge: 'Hindi',
//       author: 'Swami Adganand Maharaj',
//       favoriteFlag: 0,
//       views: 32000,
//       pagesCount: 500,
//       desription: Constants.ebookDummyDesc,
//       chaptersCount: 18,
//       versesCount: 700,
//     ),
//     EbooksModel(
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover1.png',
//       langauge: 'Hindi',
//       author: 'Swami Adganand Maharaj',
//       favoriteFlag: 0,
//       views: 32000,
//       pagesCount: 500,
//       desription: Constants.ebookDummyDesc,
//       chaptersCount: 18,
//       versesCount: 700,
//     ),
//     EbooksModel(
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover2.png',
//       langauge: 'Hindi',
//       author: 'Swami Adganand Maharaj',
//       favoriteFlag: 0,
//       views: 32000,
//       pagesCount: 500,
//       desription: Constants.ebookDummyDesc,
//       chaptersCount: 18,
//       versesCount: 700,
//     ),
//     EbooksModel(
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover3.png',
//       langauge: 'Hindi',
//       author: 'Swami Adganand Maharaj',
//       favoriteFlag: 0,
//       views: 32000,
//       pagesCount: 500,
//       desription: Constants.ebookDummyDesc,
//       chaptersCount: 18,
//       versesCount: 700,
//     ),
//     EbooksModel(
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover4.png',
//       langauge: 'Hindi',
//       author: 'Swami Adganand Maharaj',
//       favoriteFlag: 0,
//       views: 32000,
//       pagesCount: 500,
//       desription: Constants.ebookDummyDesc,
//       chaptersCount: 18,
//       versesCount: 700,
//     ),
//     EbooksModel(
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       bookCoverImgUrl: 'assets/images/ebooks_listing/book_cover5.png',
//       langauge: 'Hindi',
//       author: 'Swami Adganand Maharaj',
//       favoriteFlag: 0,
//       views: 32000,
//       pagesCount: 500,
//       desription: Constants.ebookDummyDesc,
//       chaptersCount: 18,
//       versesCount: 700,
//     ),
//   ];
//   final List<VideosModel> videoDummyList = [
//     VideosModel(
//       videoCoverImgUrl: 'assets/images/liked_list/video_cover1.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       duration: '30 mins 20 sec',
//       langauge: 'Hindi',
//       viewsCount: 32000,
//     ),
//     VideosModel(
//       videoCoverImgUrl: 'assets/images/liked_list/video_cover2.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       duration: '30 mins 20 sec',
//       langauge: 'Hindi',
//       viewsCount: 32000,
//     ),
//     VideosModel(
//       videoCoverImgUrl: 'assets/images/liked_list/video_cover3.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       duration: '30 mins 20 sec',
//       langauge: 'Hindi',
//       viewsCount: 32000,
//     ),
//     VideosModel(
//       videoCoverImgUrl: 'assets/images/liked_list/video_cover4.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       duration: '30 mins 20 sec',
//       langauge: 'Hindi',
//       viewsCount: 32000,
//     ),
//     VideosModel(
//       videoCoverImgUrl: 'assets/images/liked_list/video_cover5.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       duration: '30 mins 20 sec',
//       langauge: 'Hindi',
//       viewsCount: 32000,
//     ),
//     VideosModel(
//       videoCoverImgUrl: 'assets/images/liked_list/video_cover1.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       duration: '30 mins 20 sec',
//       langauge: 'Hindi',
//       viewsCount: 32000,
//     ),
//     VideosModel(
//       videoCoverImgUrl: 'assets/images/liked_list/video_cover2.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       duration: '30 mins 20 sec',
//       langauge: 'Hindi',
//       viewsCount: 32000,
//     ),
//     VideosModel(
//       videoCoverImgUrl: 'assets/images/liked_list/video_cover3.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       duration: '30 mins 20 sec',
//       langauge: 'Hindi',
//       viewsCount: 32000,
//     ),
//     VideosModel(
//       videoCoverImgUrl: 'assets/images/liked_list/video_cover4.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       duration: '30 mins 20 sec',
//       langauge: 'Hindi',
//       viewsCount: 32000,
//     ),
//     VideosModel(
//       videoCoverImgUrl: 'assets/images/liked_list/video_cover5.png',
//       title: 'Srimad Bhagwad Gita Padhchhed',
//       author: 'Swami Adgadanand Ji Maharaj',
//       duration: '30 mins 20 sec',
//       langauge: 'Hindi',
//       viewsCount: 32000,
//     ),
//   ];

//   fetchLikedList(String selectedLikedListTab) {
//     if (selectedLikedListTab == 'Audio') {
//       return audioBooksDummyList;
//     } else if (selectedLikedListTab == 'Books') {
//       return ebooksDummyList;
//     } else if (selectedLikedListTab == 'Video') {
//       return videoDummyList;
//     }
//   }
// }
