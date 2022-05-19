class EcabinetNoticeModel{
  String meetingcode;
  String meetingtypeid;
  String changeLogID;
  String meetingtext;

  EcabinetNoticeModel(
      this.meetingcode,
      this.meetingtypeid,
      this.changeLogID,
      this.meetingtext);

  factory EcabinetNoticeModel.fromJson(dynamic json) {
    return EcabinetNoticeModel(
      json['meetingcode'] as String,
      json['meetingtypeid'] as String,
      json['changeLogID'] as String,
      json['meetingtext'] as String,
    );
  }
}