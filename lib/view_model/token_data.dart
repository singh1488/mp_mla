class TokenList{
  List<Member> memberList;
  TokenList({this.memberList});
}

class Member {
  int Aggreementno;
  String AggrementName;

  Member({this.Aggreementno, this.AggrementName});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(Aggreementno: json['Aggreementno'], AggrementName: json['AggrementName']);
  }
}
