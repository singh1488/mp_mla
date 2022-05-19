class District {
  int r_valueid;
  String r_valuetext;
  String r_valuetext_e;

  District(
    this.r_valueid,
    this.r_valuetext,
    this.r_valuetext_e,
  );

  factory District.fromJson(dynamic json) {
    return District(
      json['r_valueid'] as int,
      json['r_valuetext'] as String,
      json['r_valuetext_e'] as String,
    );
  }
}
