const double S_PRICE_LOW_RANGE = 0;
const double S_PRICE_HIGH_RANGE = 510000;
const int S_PRICE_DIVISION = 51;
const int IF_S_PRICE_HIGH_DEFAULT = 9999999999;
const String IF_S_PERIOD_MIN_DEFAULT = "1900.01.01";
const String IF_S_PERIOD_HIGH_DEFAULT = "2900.12.31";

const double T_DEPOSIT_LOW_RANGE = 0;
const double T_DEPOSIT_HIGH_RANGE = 301000000;
const int IF_T_DEPOSIT_HIGH_DEFAULT = 9999999999;
const int T_DEPOSIT_DIVISION = 301;

const double T_MONTHLY_LOW_RANGE = 0;
const double T_MONTHLY_HIGH_RANGE = 5010000;
const int IF_T_MONTHLY_HIGH_DEFAULT = 9999999999;
const int T_MONTHLY_DIVISION = 501;
const String IF_T_PERIOD_MIN_DEFAULT = "1900.01.01";
const String IF_T_PERIOD_HIGH_DEFAULT = "2900.12.31";

String extractNum_Transfer_String(double v) {
  int target = v.toInt();
  if(target < 100000000)
  {
    if(target <= 5000000) {
      return (target / 10000).toInt().toString();
    }
    else {
      int roundTarget = ((target / 10000).toInt()) % 500;
      int returnTarget;
      if(roundTarget < 500) {
        returnTarget = (target / 10000).toInt()- roundTarget;
      }
      else {
        returnTarget = (target / 10000).toInt() - roundTarget + 500;
      }
      return returnTarget.toInt().toString();
    }
  }
  else {
    int million = target ~/ 100000000;
    int redundancy = (target % (million * 100000000)) ~/ 10000;

    int roundTarget = redundancy % 500;
    int returnTarget;

    if(roundTarget < 500) {
      returnTarget = redundancy- roundTarget;
    }
    else {
      returnTarget = redundancy - roundTarget + 500;
    }

    return million.toInt().toString() + "억"+ returnTarget.toInt().toString();
  }
}// 양도 필터링 내 가격란에서 slider 조정 시 가격 정보 렌더링을 위해 반올림하는 함수

String extractNum_Short_String(double v) {
  int target = v.toInt();
  if(target <= 50000) {
    return (target / 10000).toInt().toString();
  }
  else {
    int roundTarget = target % 50000;
    int returnTarget;

    if(roundTarget < 50000){
      returnTarget = target - roundTarget;
    }
    else {
      returnTarget = target - roundTarget + 50000;
    }

    return (returnTarget/10000).toInt().toString();
  }
}// 단기 필터링 내 가격란에서 slider 조정 시 가격 정보 렌더링을 위해 반올림하는 함수

int extractNum_Short_Int(double v) {
  int target = v.toInt();
  if(target <= 50000) {
    return target.toInt();
  }
  else {
    int roundTarget = target % 50000;
    int returnTarget;

    if(roundTarget < 50000){
      returnTarget = target - roundTarget;
    }
    else {
      returnTarget = target - roundTarget + 50000;
    }

    return returnTarget.toInt();
  }
}// 양도 필터링 내 가격란에서 slider 조정 시 가격 정보 렌더링을 위해 반올림하는 함수인데 Int로 리턴

//CheckOptionFlag