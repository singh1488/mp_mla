class ReliefDashboardModel {
  int year_id;
  String year_detail;
  int total_complaints;

  ReliefDashboardModel(this.year_id, this.year_detail, this.total_complaints);

  factory ReliefDashboardModel.fromJson(dynamic json) {
    return ReliefDashboardModel(
      json['year_id'] as int,
      json['year_detail'] as String,
      json['total_complaints'] as int,
    );
  }
}

class ReliefDashboardModel2 {
  int districtid;
  String cmdType;
  int totalcomplaint;
  int totalpending;
  int a_disposed;
  int r_disposed;

  ReliefDashboardModel2(this.cmdType, this.districtid, this.totalcomplaint,
      this.totalpending, this.a_disposed, this.r_disposed);

  factory ReliefDashboardModel2.fromJson(dynamic json) {
    return ReliefDashboardModel2(
      json['cmdType'] as String,
      json['districtid'] as int,
      json['totalcomplaint'] as int,
      json['totalpending'] as int,
      json['a_disposed'] as int,
      json['r_disposed'] as int,
    );
  }
}
