class ComplaintListModel{
  int complaintcode;
  int complaintcode1;
  String bfy_name;
  String bfy_mobile;
  String refrencedate;
  String categoryname_u;
  String targetdate;
  String status;
  String mongo_ref_key;


  ComplaintListModel(
      this.complaintcode,
      this.complaintcode1,
      this.bfy_name,
      this.bfy_mobile,
      this.refrencedate,
      this.categoryname_u,
      this.targetdate,
      this.status,
      this.mongo_ref_key);

  factory ComplaintListModel.fromJson(dynamic json) {
    return ComplaintListModel(
      json['complaintcode'] as int,
      json['complaintcode1'] as int,
      json['bfy_name'] as String,
      json['bfy_mobile'] as String,
      json['refrencedate'] as String,
      json['categoryname_u'] as String,
      json['targetdate'] as String,
      json['status'] as String,
      json['mongo_ref_key']as String,
    );
  }
}