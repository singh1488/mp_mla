class Hospital {
  int hospcd;
  String hospdetail;
  String hospdetail2;
  String hosphn;
  String hosphn2;

  Hospital(
      this.hospcd,
      this.hospdetail,
      this.hospdetail2,
      this.hosphn,
      this.hosphn2,
      );

  factory Hospital.fromJson(dynamic json) {
    return Hospital(
      json['hospcd'] as int,
      json['hospdetail'] as String,
      json['hosphn'] as String,
      json['hosphn'] as String,
      json['hosphn2'] as String,
    );
  }
}
