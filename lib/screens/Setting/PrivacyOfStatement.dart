import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';

String paper = '<내방니방>(은)는 개인정보 보호법 제30조에 따라 정보주체(고객)의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리지침을 수립․공개합니다.\n '
    '1. 개인정보의 처리목적 <내방니방>은(는) 다음의 목적을 위하여 개인정보를 처리하고 있으며, 다음의 목적 이외의 용도로는 이용하지 않습니다. - 고객 가입의사 확인, 고객에 대한 서비스 제공에 따른 본인 식별․인증, 회원자격 유지․관리, 물품 또는 서비스 공급에 따른 금액 결제, 물품 또는 서비스의 공급․배송 등\n'
    '2. 개인정보의 처리 및 보유기간 \n'
    '① <내방니방>은(는) 정보주체로부터 개인정보를 수집할 때 동의받은 개인정보 보유․이용기간 또는 법령에 따른 개인정보 보유․이용기간 내에서 개인정보를 처리․보유합니다.\n '
    '② 구체적인 개인정보 처리 및 보유 기간은 다음과 같습니다. - 고객 가입 및 관리 : 서비스 이용계약 또는 회원가입 해지시까지, 다만 채권․채무관계 잔존시에는 해당 채권․채무관계 정산시까지 - 전자상거래에서의 계약․청약철회, 대금결제, 재화 등 공급기록 : 5년\n'
    '3. 개인정보의 제3자 제공 <내방니방>은(는) 정보주체의 별도 동의, 법률의 특별한 규정 등 개인정보 보호법 제17조에 해당하는 경우 외에는 개인정보를 제3자에게 제공하지 않습니다. \n'
    '4. 개인정보처리의 위탁 \n'
    '① <내방니방>은(는) 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리업무를 외부에 위탁하고 있습니다. - A/S 센터 운영 ․위탁받는 자 (수탁자) : OO 전자 ․위탁하는 업무의 내용 : 고객 대상 제품 A/S 제공 \n'
    '② <내방니방>은(는) 위탁계약 체결시 개인정보 보호법 제25조에 따라 위탁업무 수행목적 외 개인정보 처리금지, 재위탁 제한, 수탁자에 대한 관리․감독, 책임에 관한 사항을 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다. \n'
    '5. 정보주체와 법정대리인의 권리․의무 및 행사방법 정보주체는 <내방니방>에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다. \n'
    '1. 개인정보 열람요구 \n'
    '2. 개인정보에 오류 등이 있을 경우 정정 요구 \n'
    '3. 삭제요구 \n'
    '4. 처리정지 요구 \n'
    '5. 처리하는 개인정보 항목 <내방니방>은(는) 다음의 개인정보 항목을 처리하고 있습니다. - 성명, 생년월일, 주소, 전화번호, 휴대전화번호, 성별, 이메일주소, 신용카드번호, 은행계좌번호 등 결제정보 \n'
    '6. 개인정보의 파기 \n'
    '① <내방니방>은(는) 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다. \n'
    '② <내방니방>은(는) 다음의 방법으로 개인정보를 파기합니다. - 전자적 파일 : 파일 삭제 및 디스크 등 저장매체 포맷 - 수기(手記) 문서 : 분쇄하거나 소각 \n'
    '8. 개인정보의 안전성 확보조치 <내방니방>은(는) 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다. - 관리적 조치 : 내부관리계획 수립․시행, 직원․종업원 등에 대한 정기적 교육 - 기술적 조치 : 개인정보처리시스템(또는 개인정보가 저장된 컴퓨터)의 비밀번호 설정 등 접근권한 관리, 백신소프트웨어 등 보안프로그램 설치, 개인정보가 저장된 파일의 암호화 - 물리적 조치 : 개인정보가 저장․보관된 장소의 시건, 출입통제 등 \n'
    '9. 개인정보 자동 수집 장치의 설치∙운영 및 거부에 관한 사항 \n'
    '① <내방니방>은(는) 이용자에게 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠기(cookie)’를 사용합니다. \n'
    '② 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보이며 이용자들의 PC 컴퓨터내의 하드디스크에 저장되기도 합니다. 가. 쿠키의 사용목적: 이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부, 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다. 나. 쿠키의 설치∙운영 및 거부 : 웹브라우저 상단의 도구>인터넷 옵션>개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부 할 수 있습니다. 다. 쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다. \n'
    '10. 개인정보 보호책임자 <내방니방>은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제를 처리하기 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다. ▶ 개인정보 보호책임자 (사업주 또는 대표자) 성명 : OOO 직책 : OOO 연락처 : <전화번호>, <이메일>, <팩스번호> \n'
    '11. 개인정보 처리방침 변경 이 개인정보 처리방침은 20XX. X. X.부터 적용됩니다.';

class PrivacyOfStatement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.fromLTRB(screenWidth*0.033333, 0, 0, 0),
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  backArrow,
                  width: screenWidth * 0.057777,
                  height: screenWidth * 0.057777,
                ),
              ),
            ),
          ),
          title: SvgPicture.asset(
            MryrLogo,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.033333),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight*0.03125),
                Text(
                  '개인정보처리방침',
                  style: TextStyle(
                    fontSize: screenWidth*0.0444,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: screenHeight*0.0203125,),
                Text(
                  paper,
                  style: TextStyle(
                    color: hexToColor('#888888'),
                    fontSize: screenWidth*0.0333333
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
