class Sigungu {
  final String sido;
  final List<String> gungu;

  Sigungu({
    this.sido,
    this.gungu
  });

  factory Sigungu.fromJson(Map<String, dynamic> json) {
    var sigunguFromJson = json['gungu'];
    List<String> gunguList = sigunguFromJson.cast<String>();

    return new Sigungu(
        sido: json['sido'],
        gungu: gunguList);
  }
}