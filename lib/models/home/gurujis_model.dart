class GurujisModel {
  final String gurujiImgUrl;
  final String title;

  GurujisModel({
    this.gurujiImgUrl = '',
    this.title = '',
  });

  static List<GurujisModel> gurujisModelList = [
    GurujisModel(
      gurujiImgUrl: 'assets/images/home/guruji1.png',
      title: 'Sri Paramahans Maharaj Ji',
    ),
    GurujisModel(
      gurujiImgUrl: 'assets/images/home/guruji2.png',
      title: 'Swami Adgadanand Ji Maharaj',
    ),
    GurujisModel(
      gurujiImgUrl: 'assets/images/home/guruji1.png',
      title: 'Sri Paramahans Maharaj Ji',
    ),
    GurujisModel(
      gurujiImgUrl: 'assets/images/home/guruji2.png',
      title: 'Swami Adgadanand Ji Maharaj',
    ),
  ];
}
