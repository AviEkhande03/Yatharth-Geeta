class VideosModel {
  final String videoCoverImgUrl;
  final String title;
  final String duration;
  final String langauge;
  final int viewsCount;
  final String author;

  VideosModel({
    this.duration = '',
    this.langauge = '',
    this.title = '',
    this.videoCoverImgUrl = '',
    this.author = '',
    this.viewsCount = 0,
  });

  static List<VideosModel> videosModelList1 = [
    VideosModel(
      videoCoverImgUrl: 'assets/images/home/video_cover1.png',
      title: 'Bhagvad Gita',
      duration: '30',
      langauge: 'Sanskrit',
    ),
    VideosModel(
      videoCoverImgUrl: 'assets/images/home/video_cover2.png',
      title: 'Bhagvad Gita',
      duration: '30',
      langauge: 'Sanskrit',
    ),
    VideosModel(
      videoCoverImgUrl: 'assets/images/home/video_cover1.png',
      title: 'Bhagvad Gita',
      duration: '30',
      langauge: 'Sanskrit',
    ),
    VideosModel(
      videoCoverImgUrl: 'assets/images/home/video_cover2.png',
      title: 'Bhagvad Gita',
      duration: '30',
      langauge: 'Sanskrit',
    ),
  ];
}
