class EcabinetAllMadModel{
  String displayOrderNo;
  String meetingcode;
  String agendatypeid;
  String itemComputerNo;
  String deptName;
  String subjectName;
  String subject;
  String itemDetails;
  String ministercode;
  String filenumber;

  EcabinetAllMadModel(
      this.displayOrderNo,
      this.meetingcode,
      this.agendatypeid,
      this.itemComputerNo,
      this.deptName,
      this.subjectName,
      this.subject,
      this.itemDetails,
      this.ministercode,
      this.filenumber);

  factory EcabinetAllMadModel.fromJson(dynamic json) {
    return EcabinetAllMadModel(
      json['displayOrderNo'] as String,
      json['meetingcode'] as String,
      json['agendatypeid'] as String,
      json['itemComputerNo'] as String,
      json['deptName'] as String,
      json['subjectName'] as String,
      json['subject'] as String,
      json['itemDetails'] as String,
      json['ministercode'] as String,
      json['filenumber'] as String,
    );
  }
}