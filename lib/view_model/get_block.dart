class Block {
  int r_valueid;
  String r_valuetext;
  String r_valuetext_h;

  Block(
      this.r_valueid,
      this.r_valuetext,
      this.r_valuetext_h,
      );

  factory Block.fromJson(dynamic json) {
    return Block(
      json['r_valueid'] as int,
      json['r_valuetext'] as String,
      json['r_valuetext_h'] as String,
    );
  }
}
