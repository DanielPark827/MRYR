import 'package:flutter/material.dart';

class dummySuggestRoom with ChangeNotifier {


  bool FlagForCareer = false;
  bool FlagForCertification = false;
  bool FlagForAward = false;
  bool IfThisSubField = false;
  bool IfThisGraduateSchool = false;
  bool ProfileModifyClear = false;


  //경력
  String Company = null;
  String Role =null;
  bool IfHoldOffice = false;
  String Start = null;
  String End = null;
  int Years = 0;
  int StartYears = 0;
  int EndYears = 0;
  bool UploadComplete =false;
  bool IfAddCareerComplete = false;

  List<String> CareerList = [];

  //자격증
  String CertificationName = null;
  String CertificationAgency = null;
  bool IfHaveVality = false;
  String CertificationStart = null;
  String CertificationEnd = null;
  bool CertificationUploadComplete = false;
  bool IfAddCertificationComplete = false;

  List<String> CertificationList = [];

  //수상경력
  String AwardName = null;
  String AwardGrader = null;
  String AwardAgency = null;
  String AwardTime = null;
  bool AwardUploadComplete = false;
  bool IfAddAwardComplete = false;

  List<String> AwardList = [];

  //뱃지
  List<String> BadgeList = [];

  ///////////////////////////get 함수

  bool getFlagForCareer() => FlagForCareer;
  bool getFlagForAward() => FlagForAward;
  bool getFlagForCertification() => FlagForCertification;
  bool getIfThisSubField() => IfThisSubField;



  //경력
  String getCompany() => Company ;
  String getRole() => Role ;
  bool getIfHoldOffice() => IfHoldOffice ;
  String getStart() => Start ;
  String getEnd() => End ;
  int getYears() => Years;
  int getStartYears() => StartYears;
  int getEndYears() => EndYears;
  bool getUploadComplete() => UploadComplete;
  bool getIfAddCareerComplete() => IfAddCareerComplete;

  //자격증
  String getCertificationName() => CertificationName;
  String getAgency() => CertificationAgency;
  bool getIfHaveVality () => IfHaveVality ;
  String getCertificationStart () => CertificationStart ;
  String getCertificationEnd () => CertificationEnd ;
  bool getCertificationUploadComplete () => CertificationUploadComplete ;
  bool getIfAddCertificationComplete () => IfAddCertificationComplete ;

  //수상경력
  String getAwardName() => AwardName;
  String getAwardGrader () => AwardGrader ;
  String getAwardAgency() => AwardAgency;
  String getAwardTime () => AwardTime ;
  bool getAwardUploadComplete () => AwardUploadComplete ;
  bool getIfAddAwardComplete () => IfAddAwardComplete ;



  String getCareerListComponent(int index) => CareerList[index];

  void AddCareerList(String value) {
    CareerList.add(value);
    notifyListeners();
  }
  void RemoveCareerList(int index) {
    CareerList.removeAt(index);
    notifyListeners();
  }

  String getCertificationListComponent(int index) => CertificationList[index];

  void AddCertificationList(String value) {
    CertificationList.add(value);
    notifyListeners();
  }
  void RemoveCertificationList(int index) {
    CertificationList.removeAt(index);
    notifyListeners();
  }

  String getAwardListComponent(int index) => AwardList[index];

  void AddAwardList (String value) {
    AwardList.add(value);
    notifyListeners();
  }
  void RemoveAwardList (int index) {
    AwardList.removeAt(index);
    notifyListeners();
  }

  String getBadgeListComponent(int index) => BadgeList[index];
  void AddBadgeList (String value) {
    BadgeList.add(value);
    notifyListeners();
  }
  void RemoveBadgeList (int index) {
    BadgeList.removeAt(index);
    notifyListeners();
  }

  //Flag
  void MakeFlagForCareerOn() {
    FlagForCareer = true;
    FlagForCertification = false;
    FlagForAward = false;
    notifyListeners();
  }
  void MakeFlagForAwardOn() {
    FlagForCareer = false;
    FlagForCertification = false;
    FlagForAward = true;
    notifyListeners();
  }
  void MakeFlagForCertificationOn() {
    FlagForCareer = false;
    FlagForCertification = true;
    FlagForAward = false;
    notifyListeners();
  }
  void ChangeIfThisSubField(bool value) {
    IfThisSubField = value;
    notifyListeners();
  }
  void ChangeIfThisGraduateSchool(bool value) {
    IfThisGraduateSchool = value;
    notifyListeners();
  }

  //
  void ChangeProfileModifyClear(bool value) {
    ProfileModifyClear = value;
    notifyListeners();
  }
  //수상경력
  void ChangeAwardName(String value) {
    AwardName = value;
    notifyListeners();
  }
  void ChangeAwardGrader (String value) {
    AwardGrader = value;
    notifyListeners();
  }
  void ChangeAwardAgency (String value) {
    AwardAgency  = value;
    notifyListeners();
  }
  void ChangeAwardTime (String value) {
    AwardTime  = value;
    notifyListeners();
  }
  void MakeAwardUploadCompleteOn(){
    AwardUploadComplete =true;
    notifyListeners();
  }
  void MakeAwardUploadCompleteOff(){
    AwardUploadComplete =false;
    notifyListeners();
  }
  void MakeIfAddAwardCompleteOn(){
    IfAddAwardComplete  =true;
    notifyListeners();
  }
  void MakeIfAddAwardCompleteOff(){
    IfAddAwardComplete  =false;
    notifyListeners();
  }

  //자격증
  void ChangeCertificationName(String value) {
    CertificationName = value;
    notifyListeners();
  }
  void ChangeAgency(String value) {
    CertificationAgency = value;
    notifyListeners();
  }
  void ChangeIfHaveVality() {
    IfHaveVality = !IfHaveVality;
    notifyListeners();
  }
  void ChangeCertificationStart(String value) {
    CertificationStart = value;
    notifyListeners();
  }
  void ChangeCertificationEnd(String value) {
    CertificationEnd = value;
    notifyListeners();
  }
  void MakeCertificationUploadCompleteOn() {
    CertificationUploadComplete = true;
    notifyListeners();
  }
  void MakeCertificationUploadCompleteOff() {
    CertificationUploadComplete = false;
    notifyListeners();
  }
  void MakeIfAddCertificationCompleteOn() {
    IfAddCertificationComplete = true;
    notifyListeners();
  }
  void MakeIfAddCertificationCompleteOff() {
    IfAddCertificationComplete = false;
    notifyListeners();
  }



  //경력
  void ChangeCareerCompany(String value) {
    Company = value;
    notifyListeners();
  }
  void ChangeCareerRole(String value) {
    Role = value;
    notifyListeners();
  }
  void ChangeCareerIfHoldOffice() {
    IfHoldOffice = !IfHoldOffice;
    notifyListeners();
  }
  void ChangeCareerStart(String value) {
    Start = value;
    notifyListeners();
  }
  void ChangeCareerEnd(String value) {
    End = value;
    notifyListeners();
  }
  void ChangeCareerYears(int value) {
    Years = value;
    notifyListeners();
  }
  void ChangeCareerStartYears(int value) {
    StartYears = value;
    notifyListeners();
  }
  void ChangeCareerEndYears(int value) {
    EndYears = value;
    notifyListeners();
  }
  void MakeUploadCompleteOn() {
    UploadComplete = true;
    notifyListeners();
  }
  void MakeUploadCompleteOff() {
    UploadComplete = false;
    notifyListeners();
  }
  void MakeIfAddCareerCompleteOn() {
    IfAddCareerComplete = true;
    notifyListeners();
  }
  void MakeIfAddCareerCompleteOff() {
    IfAddCareerComplete = false;
    notifyListeners();
  }
}
