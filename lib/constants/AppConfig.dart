
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mryr/chat/ChatPage.dart';
import 'package:mryr/chat/models/ChatRecvMessageModel.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/screens/LoginMainScreen.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mryr/network/ApiProvider.dart';

double screenWidth = 360;
double screenHeight = 640;
bool AllNotification = true;
const kAnimationDuration = Duration(milliseconds: 200);
const kPrimaryColor = Color(0xff7D2FBD);
const AllOptionIconColor = Color(0xffCCCCCC); //옵션 아이콘 색상
const OptionDivideLineColor = Color(0xffCCCCCC); //옵션 상세 사이에 있는 선의 색
double OptionFontSize = (12/360); ///상세 페이지 폰트 크기
double SearchCaseFontSize = (12/360); ///필터링 글자 크기
double TagFontSize = (10/360); //태그 안에 글자크기
double OptionIconFontSize =(10/360); //옵션 아이콘에 글자크기
double DialogNameFontSize = (14/360);
double DialogContentsFontSize = (10/360);
double BottomButtonMentSize = (16/360);
double ListContentsFontSize = (12/360); ///list 페이지 폰트 크기

const int DASHBOARD_SCREEN_NUM = 0;
const int LOOK_FOR_ROOMS_SCREEN_NUM = 1;
const int CHAT_LIST_SCREEN_NUM = 2;
const int MORE_SCREEN_NUM = 3;

const int ROOM_WANNA_LIVE  = 4;
const int TOTAL_NOTIFICATION_PAGE=5;

const int MAX_PREV_CHAT_MESSAGE = 20;
const int ROOM_STATUS_ROOM = 0;
const int ROOM_STATUS_CHAT = 1;
const int ROOM_STATUS_ETC = 2;

String ReleaseRoom_Splash = "ReleaseRoom_Splash";
String LookForRoom_Splash = "LookForRoom_Splash";
String IfNewUser = "IfNewUser";
String IfNewUser2 = "IfNewUser2";
String forShort = "forShort";
String forLong = "forLong";
String forReview = "forReview";

//이미지
double ImgSizeStandard = 3;
int ImgEncodeQulity = 90;

double byteToMb(int value) {
  return value / (1024*1024);
}


////////////////////////////공통함수는 여기에 추가//////////////////////////////////
Size screenSize(BuildContext context){
  return  MediaQuery.of(context).size;
}

void setScreenWidth(BuildContext context, {double divededBy = 1}){
  screenWidth = screenSize(context).width / divededBy;
}

void setScreenHeight(BuildContext context, {double divededBy = 1}){
  screenHeight = screenSize(context).height / divededBy;
}

Color hexToColor(String code) {
  //int.parse : 문자열을 정수로 파싱
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}


String GetWeekDay(String WeekDay) {
  if(WeekDay == 'Monday')
    return '월요일';
  else if(WeekDay == 'Tuesday')
    return '화요일';
  else if(WeekDay == 'Wednesday')
    return '수요일';
  else if(WeekDay == 'Thursday')
    return '목요일';
  else if(WeekDay == 'Friday')
    return '금요일';
  else if(WeekDay == 'Saturday')
    return '토요일';
  else if(WeekDay == 'Sunday')
    return '일요일';
}


final String WhiteBellIcon= 'assets/images/TotalNotification/WhiteBellIcon.svg';
final String WhiteChatIcon= 'assets/images/TotalNotification/WhiteChatIcon.svg';
final String WhiteNewsIcon= 'assets/images/TotalNotification/WhiteNewsIcon.svg';
final String WhitePeopleIcon2= 'assets/images/TotalNotification/WhitePeopleIcon2.svg';
final String teamBasicImage= 'assets/images/Chat/Team.png';

String GetNotificationIcon(String NotificationIcon) {
  if(NotificationIcon == '알림')
    return WhiteBellIcon;
  else if(NotificationIcon == '쪽지')
    return WhiteNewsIcon;
  else if(NotificationIcon == '지원')
    return WhitePeopleIcon2;
  else if(NotificationIcon == '댓글')
    return WhiteChatIcon;
}

int getValueByRoomState(ROOM_STATE state){
  switch(state){
    case ROOM_STATE.INQUIRE: return 0;
    case ROOM_STATE.REQUEST: return 1;
    case ROOM_STATE.DONE: return 2;
  }
}

ROOM_STATE getRoomStateByValue(int value){
  switch(value){
    case 0: return ROOM_STATE.INQUIRE;
    case 1: return ROOM_STATE.REQUEST;
    case 2: return ROOM_STATE.DONE;
  }
}

ROOM_STATE getRoomStateByMessageType(MESSAGE_TYPE type){
  switch(type){
    case MESSAGE_TYPE.INQUIRE: return ROOM_STATE.INQUIRE;
    case MESSAGE_TYPE.INQUIRE_CANCEL: return ROOM_STATE.INQUIRE;
    case MESSAGE_TYPE.INQUIRE_REQUEST: return ROOM_STATE.REQUEST;
    case MESSAGE_TYPE.INQUIRE_OK: return ROOM_STATE.DONE;
  }
}

MESSAGE_TYPE  getMessageTypeByInt(int type){
  switch(type){
    case 0: return MESSAGE_TYPE.MESSAGE;
    case 1: return MESSAGE_TYPE.IMAGE;
    case 2: return MESSAGE_TYPE.INQUIRE;
    case 3: return MESSAGE_TYPE.INQUIRE_REQUEST;
    case 4: return MESSAGE_TYPE.INQUIRE_OK;
    case 5: return MESSAGE_TYPE.INQUIRE_CANCEL;
    default: return MESSAGE_TYPE.MESSAGE;
  }
}

int getMessageType(MESSAGE_TYPE type){
  switch(type){
    case MESSAGE_TYPE.MESSAGE: return 0;
    case MESSAGE_TYPE.IMAGE: return 1;
    case MESSAGE_TYPE.INQUIRE: return 2;
    case MESSAGE_TYPE.INQUIRE_REQUEST: return 3;
    case MESSAGE_TYPE.INQUIRE_OK: return 4;
    case MESSAGE_TYPE.INQUIRE_CANCEL: return 5;
    default: return 0;
  }
}

String getRoomMessage(MESSAGE_TYPE type, String message){
  String res = '';

  switch(type){
    case MESSAGE_TYPE.MESSAGE: res = message; break;
    case MESSAGE_TYPE.IMAGE: res = 'Photo'; break;
    case MESSAGE_TYPE.INQUIRE: res = '문의를 보냈습니다.'; break;
    case MESSAGE_TYPE.INQUIRE_REQUEST: res = '문의를 보냈습니다.'; break;
    case MESSAGE_TYPE.INQUIRE_OK: res = '거래를 확정하였습니다.'; break;
    case MESSAGE_TYPE.INQUIRE_CANCEL: res = '거래를 취소하였습니다.'; break;
    default: res = ''; break;
  }

  return res;
}

bool isMessageType(int data, MESSAGE_TYPE type){
  return data == getMessageType(type);
}

String setRoomDate(String date){
  int hour = int.parse(date[8] + date[9]);
  int minute = int.parse(date[10] + date[11]);

  String hourStr = hour < 10 ? '0' + hour.toString() : hour.toString();
  String minuteStr = minute < 10 ? '0' + minute.toString() : minute.toString();

  return hourStr + ":" + minuteStr;
}

String setDateAmPm(String date, bool isAmPM){
  int index = date.indexOf(":");
  int sub = int.parse(date.substring(0, index));
  String subRest = date.substring(index+1, date.length);
  String AmOrPM = "오전 ";

  if(true == isAmPM){
    sub = sub + 9;
  }

  if(sub >= 12) {
    AmOrPM = "오후 ";
    sub = sub - 12;

    if(sub == 0)
      sub = 12;
  }

  return AmOrPM + sub.toString() + ":" + subRest;
}
/*
String termCheck(String date1, String date2){

  if(date1 == null || date2 == null) {
    return "기간 미기재";
  }

 var var1 =  date1.split(".");
 var var2 = date2.split(".");
 String rVal = "";

 if(int.parse(var2[0])-int.parse(var1[0])>0){
   if(int.parse(var2[1])-int.parse(var1[1])>0){
     return rVal = "1년 이상";
   }
   else if(int.parse(var2[1])-int.parse(var1[1])==0){
     if(int.parse(var2[2])-int.parse(var1[2])>=0){
       return rVal = "1년 이상";
     }
     else{
       return rVal = "1개월 이상";
     }
   }
   else{
     if(int.parse(var1[1])-int.parse(var2[1])==11){
       if(int.parse(var2[2])-int.parse(var1[2])>0){
         return rVal = "1개월 이상";
       }
       else if(int.parse(var2[2])-int.parse(var1[2])==0){
         return rVal = "1개월";
       }
       else{
         return rVal = "1개월 이내";
       }
     }
     else{
       return rVal = "1개월 이상";
     }
   }
 }
 else{
   if(int.parse(var2[1])-int.parse(var1[1])>1){
     return rVal = "1개월 이상";
   }
   else if(int.parse(var2[1])-int.parse(var1[1])==1){
     if(int.parse(var2[2])-int.parse(var1[2])>0){
       return rVal = "1개월 이상";
     }
     else if(int.parse(var2[2])-int.parse(var1[2])==0){
       return rVal = "1개월";
     }
     else{
       return rVal = "1개월 이내";
     }
   }
   else{
     return rVal = "1개월 이내";
   }
 }
}*/

String replaceDate(String date){
  int index = date.lastIndexOf('.') == -1 ? date.length : date.lastIndexOf('.');

  String replaceStr = date.substring(0, index);
  return  replaceStr.replaceAll('T', ' ').replaceAll('-', '').replaceAll(':', '').replaceAll(' ', '');
}


String replaceLocalDate(String dateStr, {isSend = false}){

  if(dateStr.contains('T')){
    DateTime date = new DateFormat("yyyy-MM-ddTHH:mm:ss.sssZ").parse( dateStr, true);

    date = date.add(Duration(hours: 9));

    String str = date.toString();
    int index = str.lastIndexOf('.') == -1 ? str.length : str.lastIndexOf('.');

    String replaceStr = str.substring(0, index);

    return  replaceStr.replaceAll('T', ' ').replaceAll('-', '').replaceAll(' ', '').replaceAll(':', '');
  }else{
    DateTime date = new DateFormat("yyyy-MM-dd HH:mm:ss.sssZ").parse( dateStr, true);
    date = date.add(Duration(hours: 9));
    String str = date.toString();
    int index = str.lastIndexOf('.') == -1 ? str.length : str.lastIndexOf('.');

    String replaceStr = str.substring(0, index);

    return  replaceStr.replaceAll('T', ' ').replaceAll('-', '').replaceAll(' ', '').replaceAll(':', '');
  }
}

String replaceDateToShow(String dateStr){
  DateTime date = new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse( dateStr, true);

  return (date.hour + 9).toString() + ":" + date.minute.toString();
}

String replaceUTCDate(String dateStr){
  DateTime date = new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(dateStr, true);
  date = date.add(Duration(hours: 9));

  return date.toLocal().toString().replaceAll('-', '').replaceAll(':', '').replaceAll('.', '').replaceAll(' ', '');
}

Future permissionRequest() async {

  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.camera,
    Permission.notification
  ].request();
}


Future<bool> getNotiByStatus() async {
  bool isNoti;
  var status = await Permission.notification.status;

  switch(status){
    case PermissionStatus.denied:
      isNoti = false;
      break;
    case PermissionStatus.granted:
      isNoti = true;
      break;
    default:
      isNoti = false;
      break;
  }

  return isNoti;
}


GestureDetector buildGoNextPage(BuildContext context, double screenHeight, double screenWidth, String route, String title) {
  return GestureDetector(
    onTap: (){
      Navigator.pushNamed(context, route);
    },
    child: Container(
      color: Colors.white,
      height: screenHeight*0.075,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenWidth*0.0333333),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screenHeight*0.025,
                ),
              ),
            ),
          ),
          Expanded(child: SizedBox()),
          SvgPicture.asset(
            GreyNextIcon,
            height: screenHeight*0.025,
            width: screenHeight*0.025,
          ),
          SizedBox(width: screenWidth*0.04444,)
        ],
      ),
    ),
  );
}

String termChange(String tmp){
  String tmp2 =  tmp[0]+tmp[1]+tmp[2]+tmp[3]+"."+tmp[5]+tmp[6]+"."+tmp[8]+tmp[9];
  return tmp2;
}



String timeCheck(String tmp) {
  if(tmp == null || tmp == '' || tmp.contains('.') == true) return '';

  if(tmp.length == 12){
    tmp = tmp.substring(0, 11) + '0' + tmp[12];
  }else if(tmp.length == 11){
    tmp = tmp.substring(0, 10) + '0' + tmp[11] + '0' + tmp[12];
  }

  int year = int.parse(tmp[0] + tmp[1] + tmp[2] + tmp[3]);
  int month = int.parse(tmp[4] + tmp[5]);
  int day = int.parse(tmp[6] + tmp[7]);
  int hour = int.parse(tmp[8] + tmp[9]);
  int minute = int.parse(tmp[10] + tmp[11]);
  int second = int.parse(tmp[12] + tmp[13]);

  final date1 = DateTime(year, month, day, hour, minute, second);
  var date2 = DateTime.now();
  final differenceDays = date2.difference(date1).inDays;
  final differenceHours = date2.difference(date1).inHours;
  final differenceMinutes = date2.difference(date1).inMinutes;
  final differenceSeconds = date2.difference(date1).inSeconds;

  if (differenceDays > 7) {
    return "$month" + "월 " + "$day" + "일";
  } else if (differenceDays == 7) {
    return "일주일전";
  } else {
    if (differenceDays > 1) {
      return "$differenceDays" + "일전";
    } else if (differenceDays == 1) {
      return "하루전";
    } else{
      if (differenceHours >= 1) {
        return "$differenceHours" + "시간전";
      } else {
        if (differenceMinutes >= 1) {
          return "$differenceMinutes" + "분전";
        } else {
          if(differenceSeconds>=0){
            return "$differenceSeconds" +"초전";
          }
          else{
            return "0초전";
          }
        }
      }
    }
  }
}

String getRoomTime(DateTime date){

  String year = date.year.toString();
  String month = date.month < 10 ? '0' + date.month.toString() : date.month.toString();
  String day = date.day < 10 ? '0' + date.day.toString() : date.day.toString();
  String hour = date.hour < 10 ? '0' + date.hour.toString() : date.hour.toString();
  String minute = date.minute < 10 ? '0' + date.minute.toString() : date.minute.toString();
  String second = date.second < 10 ? '0' + date.second.toString() : date.second.toString();

  return year + month + day + hour + minute + second;
}

void DialogForExitRegistration(BuildContext context, double screenHeight, double screenWidth) {
  Function okFunc = () async{
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginMainScreen()),

    );
  };

  Function cancelFunc = () {
    Navigator.pop(context);
  };

  OKCancelDialog(context,'회원가입을 종료하시겠습니까?','확인을 누르시면 지금까지 입력한 데이터는 사라집니다.\n계속하시겠습니까?',"확인","취소",okFunc,cancelFunc);
}

String get_resize_image_name( String image_url, int size) {
  final String _baseUrl = "https://mryr-development.s3.ap-northeast-2.amazonaws.com/";
  // final String _baseUrl = "https://mryr-production.s3.ap-northeast-2.amazonaws.com/";

  var splitUrl = image_url.split("/");
  var resized_image_url1 = splitUrl[0] + "_" + size.toString() + "/" + splitUrl[1];
  String resized_image_url = _baseUrl+splitUrl[3]+ "_" + size.toString() + "/"+splitUrl[splitUrl.length-1];
  return resized_image_url;
}

SizedBox widthPadding(double screenWidth, double value) => SizedBox(width: screenWidth*(value/360),);
SizedBox heightPadding(double screenHeight, double value) => SizedBox(height: screenHeight*(value/640),);

String returnRoomType(int value) {
  return value == 0 ? '원룸' : value == 1 ? '투룸 이상' : value == 2 ? '오피스텔' : '아파트';
}



bool doubleCheck = false;

DateTime replaceDateToDatetime(String dateStr, {isSend = false}){

  if(dateStr.contains('T')){
    DateTime date = new DateFormat("yyyy-MM-ddTHH:mm:ss.sssZ").parse( dateStr, true);

    date = date.add(Duration(hours: 9));
    return date;
  }else{
    DateTime date = new DateFormat("yyyy-MM-dd HH:mm:ss.sssZ").parse( dateStr, true);
    date = date.add(Duration(hours: 9));

    return date;
  }
}

Center emptySnail(double screenHeight, double screenWidth, String value) {
  return Center(
    child: Container(
      child: Column(
        children: [
          SvgPicture.asset(
            Snail,
            width: screenHeight * (112 / 640),
            height: screenHeight * (100 / 640),
          ),
          heightPadding(screenHeight,20),
          Text(
              value,
              style:TextStyle(
                  fontSize:screenWidth*(12/360),
                  color:hexToColor('#888888')
              )
          )
        ],
      ),
    ),
  );
}

class Triangle extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var path = new Path();
    path.lineTo(size.width,size.height);
    path.lineTo(size.width,0);

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}
