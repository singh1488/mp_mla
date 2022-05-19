class VillagePanchayat {
  int value_id;
  String value_text_u;
  String value_text;

  VillagePanchayat(
      this.value_id,
      this.value_text_u,
      this.value_text,
      );

  factory VillagePanchayat.fromJson(dynamic json) {
    return VillagePanchayat(
      json['value_id'] as int,
      json['value_text_u'] as String,
      json['value_text'] as String,
    );
  }
}
