class IgrsDashboardModel{
  int comp_type;
  String display_header;
  String displayheadercode;
  int totalcom;
  int totalpendingall;
  int totaldisposed;
  int totalpending;
  int totaltp;
  int total_atrss;
  int totalunmarked;
  int refetype;


  IgrsDashboardModel(
      this.comp_type,
      this.display_header,
      this.displayheadercode,
      this.totalcom,
      this.totalpendingall,
      this.totaldisposed,
      this.totalpending,
      this.totaltp,
      this.total_atrss,
      this.totalunmarked,
      this.refetype);

  factory IgrsDashboardModel.fromJson(dynamic json) {
    return IgrsDashboardModel(
      json['comp_type'] as int,
      json['display_header'] as String,
      json['displayheadercode'] as String,
      json['totalcom'] as int,
      json['totalpendingall'] as int,
      json['totaldisposed'] as int,
      json['totalpending'] as int,
      json['totaltp'] as int,
      json['total_atrss'] as int,
      json['totalunmarked'] as int,
      json['refetype'] as int,
    );
  }
}