class ArtikMadadModel {
  int rno;
  String officer_name;
  int districtid;
  int total_complaint;
  int total_atrs;
  int total_pending;
  int a_disposed;
  int r_disposed;
  int district_id;
  String cmdType;
  int year_id;

  ArtikMadadModel(
      this.rno,
      this.officer_name,
      this.districtid,
      this.total_complaint,
      this.total_atrs,
      this.total_pending,
      this.a_disposed,
      this.r_disposed,
      this.district_id,
      this.cmdType,
      this.year_id);

  factory ArtikMadadModel.fromJson(dynamic json) {
    return ArtikMadadModel(
      json['rno'] as int,
      json['officer_name'] as String,
      json['districtid'] as int,
      json['total_complaint'] as int,
      json['total_atrs'] as int,
      json['total_pending'] as int,
      json['a_disposed'] as int,
      json['r_disposed'] as int,
      json['district_id'] as int,
      json['cmdType'] as String,
      json['year_id'] as int,
    );
  }
}
