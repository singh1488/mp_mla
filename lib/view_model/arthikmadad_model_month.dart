class ArtikMadadModelMonth {
  int year_id;
  String year_detail;
  int total_complaints;

  ArtikMadadModelMonth(
      this.year_id,
      this.year_detail,
      this.total_complaints
      );

  factory ArtikMadadModelMonth.fromJson(dynamic json) {
    return ArtikMadadModelMonth(
      json['year_id'] as int,
      json['year_detail'] as String,
      json['total_complaints'] as int,

    );
  }
}
