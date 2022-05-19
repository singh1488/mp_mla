class Ward {
  int r_valueid;
  String r_valuetext;
  String r_valuetexte;

  Ward(
    this.r_valueid,
    this.r_valuetext,
    this.r_valuetexte,
  );

  factory Ward.fromJson(dynamic json) {
    return Ward(
      json['r_valueid'] as int,
      json['r_valuetext'] as String,
      json['r_valuetexte'] as String,
    );
  }
}
