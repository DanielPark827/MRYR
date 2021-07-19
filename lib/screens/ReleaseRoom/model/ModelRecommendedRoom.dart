class ModelRecommendedRoom {
  int id;
  int UserID;
  int Type;
  int DepositeFeesMin;
  int DepositeFeesMax;
  int MonthlyFeesMin;
  int MonthlyFeesMax;
  String TermOfLeaseMin;
  String TermOfLeaseMax;
  int PreferTerm;
  int PreferSex;
  int SmokingPossible;
  String Location;
  String updateAt;
  String createAt;

  ModelRecommendedRoom({this.id,this.UserID,this.updateAt,this.createAt,this.DepositeFeesMax,this.DepositeFeesMin,this.Location,this.MonthlyFeesMax,this.MonthlyFeesMin,this.PreferSex
  ,this.PreferTerm,this.SmokingPossible,this.TermOfLeaseMax,this.TermOfLeaseMin,this.Type});

  factory ModelRecommendedRoom.fromJson(Map<String, dynamic> json){
    return ModelRecommendedRoom(
      id: json['id'] as int,
      UserID: json['UserID'] as int,
      Type: json['Type'] as int,
      DepositeFeesMin: json['DepositeFeesMin'] as int,
      DepositeFeesMax: json['DepositeFeesMax'] as int,
      MonthlyFeesMin: json['MonthlyFeesMin'] as int,
      MonthlyFeesMax: json['MonthlyFeesMax'] as int,

      TermOfLeaseMin: json['TermOfLeaseMin'] as String,
      TermOfLeaseMax: json['TermOfLeaseMax'] as String,

      PreferTerm: json['PreferTerm'] as int,
      PreferSex: json['PreferSex'] as int,
      SmokingPossible: json['SmokingPossible'] as int,

      Location: json['Location'] as String,
      updateAt: json['updateAt'] as String,
      createAt: json['createAt'] as String,
    );
  }
}