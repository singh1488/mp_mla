class UserModel {
  int user_id;
  int mis_id;
  String user_name;
  String u_password;
  String r_name;
  String r_name_hindi;
  String mobileno1;
  String mobileno2;
  String r_emailid;
  String r_phoneno;
  String user_type;
  int user_level;
  String state_id;
  int distict_id;
  int post_id;
  String post_name;
  int const_id;
  String constname;
  int is_lock;


  UserModel(
      this.user_id,
      this.mis_id,
      this.user_name,
      this.u_password,
      this.r_name,
      this.r_name_hindi,
      this.mobileno1,
      this.mobileno2,
      this.r_emailid,
      this.r_phoneno,
      this.user_type,
      this.user_level,
      this.state_id,
      this.distict_id,
      this.post_id,
      this.post_name,
      this.const_id,
      this.constname,
      this.is_lock);

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
        json['user_id'] as int,
        json['mis_id'] as int,
        json['user_name'] as String,
        json['u_password'] as String,
        json['r_name'] as String,
        json['r_name_hindi'] as String,
        json['mobileno1'] as String,
        json['mobileno2'] as String,
        json['r_emailid'] as String,
        json['r_phoneno'] as String,
        json['user_type'] as String,
        json['user_level'] as int,
        json['state_id'] as String,
        json['distict_id'] as int,
        json['post_id'] as int,
        json['post_name'] as String,
        json['const_id'] as int,
        json['constname'] as String,
        json['is_lock'] as int,
    );
  }
}
