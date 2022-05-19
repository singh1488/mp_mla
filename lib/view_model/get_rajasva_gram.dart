class RajasvaGram {
  int value_id;
  String value_text_u;
  String value_text;

  RajasvaGram(
      this.value_id,
      this.value_text_u,
      this.value_text,
      );

  factory RajasvaGram.fromJson(dynamic json) {
    return RajasvaGram(
      json['value_id'] as int,
      json['value_text_u'] as String,
      json['value_text'] as String,
    );
  }
}
