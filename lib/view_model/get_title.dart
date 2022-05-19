class GetTitle {
  int value_id;
  String value_text_u;
  String value_text;

  GetTitle(
      this.value_id,
      this.value_text_u,
      this.value_text,
      );

  factory GetTitle.fromJson(dynamic json) {
    return GetTitle(
      json['value_id'] as int,
      json['value_text_u'] as String,
      json['value_text'] as String,
    );
  }
}
