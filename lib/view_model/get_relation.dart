class GetRelation {
  int value_id;
  String value_text_u;
  String value_text;

  GetRelation(
      this.value_id,
      this.value_text_u,
      this.value_text,
      );

  factory GetRelation.fromJson(dynamic json) {
    return GetRelation(
      json['value_id'] as int,
      json['value_text_u'] as String,
      json['value_text'] as String,
    );
  }
}
