class ArthikComplaintDetailModel{
  int r_no;
  int district_id;
  int complaint_code;
  int forward_id;
  String remarks;
  String department_name;
  String category_name;
  String app_details;
  String bfy_mobile;
  String comp_status;
  String created_date;
  String bfy_details;
  String officer_name;
  String markingtype;
  String recomm_details;
  String d_flag;
  String h_flag;
  String o_flag;
  String tree;
  String mongo_ref_key;

  ArthikComplaintDetailModel(
      this.r_no,
      this.district_id,
      this.complaint_code,
      this.forward_id,
      this.remarks,
      this.department_name,
      this.category_name,
      this.app_details,
      this.bfy_mobile,
      this.comp_status,
      this.created_date,
      this.bfy_details,
      this.officer_name,
      this.markingtype,
      this.recomm_details,
      this.d_flag,
      this.h_flag,
      this.o_flag,
      this.tree,
      this.mongo_ref_key);

  factory ArthikComplaintDetailModel.fromJson(dynamic json) {
    return ArthikComplaintDetailModel(
      json['r_no'] as int,
      json['district_id'] as int,
      json['complaint_code'] as int,
      json['forward_id'] as int,
      json['remarks'] as String,
      json['department_name'] as String,
      json['category_name'] as String,
      json['app_details'] as String,
      json['bfy_mobile'] as String,
      json['comp_status'] as String,
      json['created_date'] as String,
      json['bfy_details'] as String,
      json['officer_name'] as String,
      json['markingtype'] as String,
      json['recomm_details'] as String,
      json['d_flag'] as String,
      json['h_flag'] as String,
      json['o_flag'] as String,
      json['tree'] as String,
      json['mongo_ref_key']as String,

    );
  }
}