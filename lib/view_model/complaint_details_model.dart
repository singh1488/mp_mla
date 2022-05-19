class ComplaintDetailModel{
  String r_forwordflag;
  int r_complaintcode;
  String r_bfymob1;
  String r_bfy_name;
  String r_bfy_fname;
  String r_bfy_address;
  String r_app_reliefdesired;
  String r_created;
  String r_feedbackstatus;
  String r_feedbackstatus_public;
  String r_feedback;
  String r_feedback_date;
  String r_reminder_flag;
  String r_is_feedback;
  int r_doc_flag;
  String r_mongo_ref_key;
  String r_comp_type;
  String r_comp_status;
  String r_ref_type;
  int r_ref_type_id;
  String r_anyacategory;
  String r_sourcename;
  String r_naturename;
  String r_levelname;
  String r_recommname;
  String r_recommdetails;
  String r_recommemail;
  String r_recommmob1;
  String r_recommmob2;
  String r_categoryname;
  String r_departmentname;
  String r_postname;
  String r_feedbackstatusnew;
  String r_feedbackdate;
  String r_feedbackremark;
  String r_tree;


  ComplaintDetailModel(
      this.r_forwordflag,
      this.r_complaintcode,
      this.r_bfymob1,
      this.r_bfy_name,
      this.r_bfy_fname,
      this.r_bfy_address,
      this.r_app_reliefdesired,
      this.r_created,
      this.r_feedbackstatus,
      this.r_feedbackstatus_public,
      this.r_feedback,
      this.r_feedback_date,
      this.r_reminder_flag,
      this.r_is_feedback,
      this.r_doc_flag,
      this.r_mongo_ref_key,
      this.r_comp_type,
      this.r_comp_status,
      this.r_ref_type,
      this.r_ref_type_id,
      this.r_anyacategory,
      this.r_sourcename,
      this.r_naturename,
      this.r_levelname,
      this.r_recommname,
      this.r_recommdetails,
      this.r_recommemail,
      this.r_recommmob1,
      this.r_recommmob2,
      this.r_categoryname,
      this.r_departmentname,
      this.r_postname,
      this.r_feedbackstatusnew,
      this.r_feedbackdate,
      this.r_feedbackremark,
      this.r_tree);

  factory ComplaintDetailModel.fromJson(dynamic json) {
    return ComplaintDetailModel(
      json['r_forwordflag'] as String,
      json['r_complaintcode'] as int,
      json['r_bfymob1'] as String,
      json['r_bfy_name'] as String,
      json['r_bfy_fname'] as String,
      json['r_bfy_address'] as String,
      json['r_app_reliefdesired'] as String,
      json['r_created'] as String,
      json['r_feedbackstatus'] as String,
      json['r_feedbackstatus_public'] as String,
      json['r_feedback'] as String,
      json['r_feedback_date'] as String,
      json['r_reminder_flag'] as String,
      json['r_is_feedback'] as String,
      json['r_doc_flag'] as int,
      json['r_mongo_ref_key'] as String,
      json['r_comp_type'] as String,
      json['r_comp_status'] as String,
      json['r_ref_type'] as String,
      json['r_ref_type_id'] as int,
      json['r_anyacategory'] as String,
      json['r_sourcename'] as String,
      json['r_naturename'] as String,
      json['r_levelname'] as String,
      json['r_recommname'] as String,
      json['r_recommdetails'] as String,
      json['r_recommemail'] as String,
      json['r_recommmob1'] as String,
      json['r_recommmob2'] as String,
      json['r_categoryname'] as String,
      json['r_departmentname'] as String,
      json['r_postname'] as String,
      json['r_feedbackstatusnew'] as String,
      json['r_feedbackdate'] as String,
      json['r_feedbackremark'] as String,
      json['r_tree'] as String,
    );
  }
}