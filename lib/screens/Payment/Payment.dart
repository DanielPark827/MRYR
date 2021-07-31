import 'package:flutter/material.dart';

/* 아임포트 결제 모듈을 불러옵니다. */
import 'package:iamport_flutter/iamport_payment.dart';
/* 아임포트 결제 데이터 모델을 불러옵니다. */
import 'package:iamport_flutter/model/payment_data.dart';

void main() => runApp(Payment());

/// example widget showing how to use signature widget
class Payment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IamportPayment(
        appBar: new AppBar(
          title: new Text('아임포트 결제'),
        ),
        /* 웹뷰 로딩 컴포넌트 */
        initialChild: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/iamport-logo.png'),
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                  child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
                ),
              ],
            ),
          ),
        ),
        /* [필수입력] 가맹점 식별코드 */
        userCode: 'iamport',
        /* [필수입력] 결제 데이터 */
        data: PaymentData.fromJson({
          'pg': 'html5_inicis',                                          // PG사
          'payMethod': 'card',                                           // 결제수단
          'name': '아임포트 결제데이터 분석',                                  // 주문명
          'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
          'amount': 1234,                                               // 결제금액
          'buyerName': '홍길동',                                           // 구매자 이름
          'buyerTel': '01012345678',                                     // 구매자 연락처
          'buyerEmail': 'example@naver.com',                             // 구매자 이메일
          'buyerAddr': '서울시 강남구 신사동 661-16',                         // 구매자 주소
          'buyerPostcode': '06018',                                      // 구매자 우편번호
          'appScheme': 'example',                                        // 앱 URL scheme
          'display' : {
            'cardQuota' : [2,3]                                            //결제창 UI 내 할부개월수 제한
          }
        }),
        /* [필수입력] 콜백 함수 */
        callback: (Map<String, String> result) {
          Navigator.pushReplacementNamed(
            context,
            '/certification-id-result',
            arguments: result,
          );
        },
      ),
    );
  }
}