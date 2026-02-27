class OnBoardingModel{
  final String _imageUrl;
  final String _frameImageUrl;
  final String _title;
  final String _description;

  String get imageUrl => _imageUrl;
  String get frameImageUrl => _frameImageUrl;
  String get title => _title;
  String get description => _description;

  OnBoardingModel(this._imageUrl, this._frameImageUrl, this._title, this._description);
}