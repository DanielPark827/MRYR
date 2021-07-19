class ModelRoomRecommend {
  int id;
  int UserID;
  int Type;
  int DepositeFeesMin;
  int DepositeFeesMax;
  int MonthlyFeesMin;
  int MonthlyFeesMax;
  String TermOfLeaseMin;
  String TermOfLeaseMax;
  int PerferTerm;
  int PreferSex;
  int SmokingPossible;
  String Location;
  String createdAt;
  String updatedAt;

  ModelRoomRecommend({this.id,this.updatedAt,this.createdAt,this.MonthlyFeesMin,this.TermOfLeaseMin,this.DepositeFeesMin,this.PreferSex,this.SmokingPossible,this.Type,this.TermOfLeaseMax,this.MonthlyFeesMax
  ,this.Location,this.DepositeFeesMax,this.UserID,this.PerferTerm});

  factory ModelRoomRecommend.fromJson(Map<String, dynamic> json){
    return ModelRoomRecommend(
      id: json['id'] as int,
      UserID: json['UserID'] as int,
      Type: json['Type'] as int,
      DepositeFeesMin: json['DepositeFeesMin'] as int,
      DepositeFeesMax: json['DepositeFeesMax'] as int,
      MonthlyFeesMin: json['MonthlyFeesMin'] as int,
      MonthlyFeesMax: json['MonthlyFeesMax'] as int,
      TermOfLeaseMin: json['TermOfLeaseMin'] as String,
      TermOfLeaseMax: json['TermOfLeaseMax'] as String,
      PerferTerm: json['PerferTerm'] as int,
      PreferSex: json['PreferSex'] as int,
      SmokingPossible: json['SmokingPossible'] as int,
      Location: json['Location'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
}