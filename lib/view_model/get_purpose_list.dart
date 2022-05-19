class Purpose {
  int pcode;
  String pdesc;


  Purpose(
      this.pcode,
      this.pdesc,

      );

  factory Purpose.fromJson(dynamic json) {
    return Purpose(
      json['pcode'] as int,
      json['pdesc'] as String,

    );
  }
}
