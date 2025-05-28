class SelectLanguageModel {
  final String title;
  final String nativeText;
  final String bgImgUrl;
  final bool isDefault;
  final String languageCode;

  SelectLanguageModel({
    required this.title,
    this.isDefault = false,
    this.nativeText = '',
    required this.bgImgUrl,
    this.languageCode = '',
  });
}
