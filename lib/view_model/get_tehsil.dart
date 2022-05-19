class Tehsil {
  int r_valueid;
  String r_valuetext;
  String r_valuetext_h;

  Tehsil(
    this.r_valueid,
    this.r_valuetext,
    this.r_valuetext_h,
  );

  factory Tehsil.fromJson(dynamic json) {
    return Tehsil(
      json['r_valueid'] as int,
      json['r_valuetext'] as String,
      json['r_valuetext_h'] as String,
    );
  }
}
