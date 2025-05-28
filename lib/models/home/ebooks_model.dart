import '../../const/constants/constants.dart';

class EbooksModel {
  final String title;
  final String bookCoverImgUrl;
  final String langauge;
  final String author;
  final int favoriteFlag;
  final int views;
  final String desription;
  final int chaptersCount;
  final int versesCount;
  final int pagesCount;
  final String audioCoverImgUrl;
  final String videoCoverImgUrl;
  final String audioLanguage;
  final String audioAuthor;
  final String audioTitle;
  final String audioDuration;
  final String audioPlaysCount;
  final String videoLanguage;
  final String videoAuthor;
  final String videoTitle;
  final String videoDuration;
  final String videoPlaysCount;

  EbooksModel({
    this.bookCoverImgUrl = '',
    this.langauge = '',
    this.title = '',
    this.author = '',
    this.favoriteFlag = 0,
    this.views = 0,
    this.desription = '',
    this.chaptersCount = 0,
    this.versesCount = 0,
    this.pagesCount = 0,
    this.audioAuthor = '',
    this.audioCoverImgUrl = '',
    this.audioDuration = '',
    this.audioLanguage = '',
    this.audioPlaysCount = '',
    this.audioTitle = '',
    this.videoAuthor = '',
    this.videoCoverImgUrl = '',
    this.videoDuration = '',
    this.videoLanguage = '',
    this.videoPlaysCount = '',
    this.videoTitle = '',
  });

  static List<EbooksModel> ebooksList1 = [
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/home/book_cover1.png',
      langauge: 'Sanskrit',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/home/book_cover2.png',
      langauge: 'Kannada',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/home/book_cover3.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/home/book_cover1.png',
      langauge: 'Sanskrit',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/home/book_cover2.png',
      langauge: 'Kannada',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/home/book_cover3.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
  ];

  static List<EbooksModel> ebooksList2 = [
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/home/book_cover3.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/home/book_cover1.png',
      langauge: 'Sanskrit',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/home/book_cover2.png',
      langauge: 'Kannada',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/home/book_cover3.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/home/book_cover1.png',
      langauge: 'Sanskrit',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/home/book_cover2.png',
      langauge: 'Kannada',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
  ];

  static List<EbooksModel> ebooksList3 = [
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/quote.png',
      langauge: 'Sanskrit',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/quote.png',
      langauge: 'Kannada',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/quote.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/quote.png',
      langauge: 'Sanskrit',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/quote.png',
      langauge: 'Kannada',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
    EbooksModel(
      title: 'Bhagvad Gita',
      bookCoverImgUrl: 'assets/images/quote.png',
      langauge: 'Hindi',
      author: 'Swami Adganand Maharaj',
      favoriteFlag: 0,
      views: 32000,
      pagesCount: 500,
      desription: Constants.ebookDummyDesc,
      chaptersCount: 18,
      versesCount: 700,
    ),
  ];
}
