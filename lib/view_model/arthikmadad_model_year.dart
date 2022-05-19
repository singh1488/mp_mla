class ArtikMadadModelYear {
  int year_id;
  String year_detail;
  int total_complaints;

  ArtikMadadModelYear(
      this.year_id,
      this.year_detail,
      this.total_complaints
      );

  factory ArtikMadadModelYear.fromJson(dynamic json) {
    return ArtikMadadModelYear(
      json['year_id'] as int,
      json['year_detail'] as String,
      json['total_complaints'] as int,

    );
  }
}
